class SksParser
  require 'PP'

  class StateMachine
    attr_accessor(:dump_hash)

    def initialize()
      @state = S_READING_UID
      @dump_hash = {}
      @keyid = ''
    end

    # enumerate states
    S_READING_UID = 0
    S_READING_USER = 1
    S_READING_SIGS = 2
    S_READING_SUBS = 3

    STATE_HASH = {
        S_READING_UID => 'S_READING_UID',
        S_READING_USER => 'S_READING_USER',
        S_READING_SIGS => 'S_READING_SIGS',
        S_READING_SUBS => 'S_READING_SUBS'
    }

    def self.get_dump_hash_from(dump)
      sm = StateMachine.new
      dump.each do |line|
        sm.process(line)
      end
      puts pp(sm.dump_hash)
    end


    def state=(new_state)
      #puts "Transitioning #{STATE_HASH[@state]}->#{STATE_HASH[new_state]}"
      @state = new_state
    end

    def process(line)
      case @state
        when S_READING_UID
          process_uid_line(line)
        when S_READING_USER
          process_user_line(line)
        when S_READING_SIGS
          process_sig_line(line)
        when S_READING_SUBS
          process_sub_line(line)
        else
          raise 'invalid state detected'
      end
    end

    def process_uid_line(line)
      if line.start_with?('keyid')
        @keyid = line.split(' ')[1]
        @dump_hash[@keyid] = {}
        self.state = S_READING_USER
      else
        return
      end
    end

    def process_user_line(line)
      @dump_hash[@keyid][:user] = line.split(' ', 4)[3][1..-2]
      @dump_hash[@keyid][:sigs] = []
      #puts "adding user: #{@dump_hash[@keyid]}"
      self.state = S_READING_SIGS
    end

    def process_sig_line(line)
      if line.start_with?(':signature')
        @dump_hash[@keyid][:sigs] << line.split(' ')[5]
      end
      if line.start_with?(':public sub')
        self.state = S_READING_SUBS
      elsif line.start_with?(':public key')
        self.state = S_READING_UID
      elsif line.start_with?(':user')
        self.state = S_READING_UID
      end
    end

    def process_sub_line(line)
      if line.start_with?(':public key')
        self.state = S_READING_UID
      end
    end

  end

  def self.dump
    output = []
    cmd = 'gpg --list-packets dumps/sks-dump-0000.pgp'
    IO.popen(cmd).each do |line|
      output << line.chomp.gsub(/\t/, '')
    end
    output
  end

  def self.parse_dump(dump)
    StateMachine.get_dump_hash_from(dump)
  end

  self.parse_dump(self.dump)



end