require "logger"
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "minitest_helper")

class Hotspots
  describe "OptionsParser" do
    let(:info_log_level) { ::Logger::INFO }
    let(:error_log_level) { ::Logger::ERROR }
    let(:logger) { ::Logger.new(STDOUT) }
    let(:configuration) { Configuration.new(:logger => logger, :info_log_level => info_log_level, :error_log_level => error_log_level) }
    let(:parser) { OptionsParser.new(:configuration => configuration) }

    describe "#parse" do
      ["--repository", "-r"].each do |option|
        describe option do
          it "sets the specified value repository" do
            parser.parse(option, "rails").repository.must_equal "rails"
          end

          it "sets empty repository when missing" do
            parser.parse(option).repository.must_equal ""
          end
        end
      end

      ["--time", "-t"].each do |option|
        describe option do
          it "sets the specified time to consider" do
            parser.parse(option, "8").time.must_equal 8
          end

          it "sets zero time when missing" do
            parser.parse(option).time.must_equal 0
          end
        end
      end

      ["--cutoff", "-c"].each do |option|
        describe option do
          it "sets the specified cutoff" do
            parser.parse(option, "5").cutoff.must_equal 5
          end

          it "sets zero cutoff when missing" do
            parser.parse(option).cutoff.must_equal 0
          end
        end
      end

      ["--file-filter", "-f"].each do |option|
        describe option do
          it "sets the specified file-filter" do
            parser.parse(option, "rb").file_filter.must_equal "rb"
          end

          it "sets empty file-filter when missing" do
            parser.parse(option).file_filter.must_equal ""
          end
        end
      end

      ["--message-filter", "-m"].each do |option|
        describe option do
          it "sets the specified message filters" do
            parser.parse(option, "cleanup|defect").message_filters.must_equal ["cleanup", "defect"]
          end

          it "sets empty message-filter when missing" do
            parser.parse(option).message_filters.must_equal []
          end
        end
      end

      ["--verbose", "-v"].each do |option|
        describe option do
          it "sets the log level to info" do
            parser.parse(option).log_level.must_equal info_log_level
          end
        end
      end

      ["--version"].each do |option|
        describe option do
          it "sets exit code to zero" do
            parser.parse(option).exit_strategy.code.must_equal 0
          end

          it "sets a version message" do
            parser.parse(option).exit_strategy.message.must_be :include?, ::Hotspots::VERSION
          end
        end
      end

      ["--help", "-h"].each do |option|
        describe option do
          it "sets exit code to zero" do
            parser.parse(option).exit_strategy.code.must_equal 0
          end

          it "sets an exit message" do
            parser.parse(option).exit_strategy.message.wont_be_empty
          end
        end
      end

      it "doesn't mutate options" do
        parser.parse("--help")
        configuration.exit_strategy.code.must_be :nil?
      end

      describe "when parsing an invalid option" do
        let(:options) { parser.parse("--invalid-option") }

        it "sets an exit code" do
          options.exit_strategy.code.must_equal 1
        end

        it "sets an exit message" do
          options.exit_strategy.message.wont_be_empty
        end
      end

      describe "when parsing an invalid argument" do
        let(:options) { parser.parse("--repository", "") }

        it "sets an exit code" do
          options.exit_strategy.code.must_equal 1
        end

        it "sets an exit message" do
          options.exit_strategy.message.wont_be_empty
        end
      end
    end
  end
end
