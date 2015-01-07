require 'hosts'
require 'optparse'
require 'shellwords'

class HostManager
  def initialize(hostsfile_path, hosts, section_name, ip, verbose = false)
    @hostsfile = Hosts::File.read(hostsfile_path)
    @hosts = hosts
    @section = init_section("maphosts - #{section_name}")
    @ip = ip
    @dirty = false
    @verbose = verbose
  end

  def patch
    migrate_hosts(@section, @hostsfile, @hosts)

    @hosts.each do |hostname|
      host = @section.elements.find { |h| h.respond_to?(:name) && h.name == hostname }

      if !host
        log '+', hostname, "will be added"
        @section.elements << Hosts::Entry.new(@ip, hostname)
        @dirty = true
      else
        if host.address != @ip
          log '*', hostname, "is pointing to #{host.address} instead of #{@ip}"
          host.address = @ip
          @dirty = true
        else
          log '*', hostname, "is already set up correctly"
        end
      end
    end

    if !@dirty
      nil
    else
      # Strip whitespace at end of file
      if !@hostsfile.elements.last.nil? && @hostsfile.elements.last.kind_of?(Hosts::EmptyElement)
        @hostsfile.elements.delete @hostsfile.elements.last
      end

      @hostsfile
    end
  end

  private
    def log(symbol, hostname, status)
      if @verbose
        puts "#{symbol} #{hostname} #{status}"
      end
    end

    def init_section(identifier)
      @section = @hostsfile.elements.find {|e| e.respond_to?(:name) && e.name == identifier}

      if !@section
        @section = Hosts::Section.new(identifier)
        @hostsfile.elements << @section
      end

      @section
    end

    def migrate_hosts(section, hostsfile, hosts)
      hosts.each do |hostname|
        host = hostsfile.elements.find { |h| h.respond_to?(:name) && h.name == hostname }

        if host
          hostsfile.elements.delete host
          section.elements << host

          log '*', hostname, "will be migrated"
        end
      end
    end
end
