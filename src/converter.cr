class Converter

    @number : String
    @bit : Int32

    def initialize(number)
        @number = number
        @bit = 0
        if @number.size == 32
            @bit = 32
        elsif @number.size == 64
            @bit == 64
        elsif @number.size == 128
            @bit = 128
        end
    end

    def split()
        ieee = ""
        if @bit == 32
            if ieee = /([0-9]{1})([0-9]{8})([0-9]{23})/.match(@number)
            else
                Process.exit(0)
            end
        elsif @bit == 64
            if ieee = /([0-9]{1})([0-9]{11})([0-9]{52})/.match(@number)
            else
                Process.exit(0)
            end
        elsif @bit == 128
            if ieee = /([0-9]{1})([0-9]{15})([0-9]{112})/.match(@number)
            else
                Process.exit(0)
            end
        else
            Process.exit(0)
        end
        ieee
    end

    def convertExponent()
        source = split()
        bias = 0

        if @bit == 32
            bias = 127
        elsif @bit == 64
            bias = 1023
        elsif @bit == 128
            bias = 16383
        end

        exponent_b = source[2].to_i(2) - bias
        exponent_d = 2 ** exponent_b
        puts exponent_b
        exponent_d
    end

    def convertFraction()
        source = split()
        fraction = parse(source[3])
        fraction
    end

    def parse(source)
        sum = 1
        array = source.split(//)
        array.each_with_index do |num,i|
            sum += num.to_f / (2**(i+1))
        end
        puts sum
        sum
    end

    def print()
        source = split()
        sign = 1
        sign = -1 if source[1].to_i == 1

        puts ("復元値:#{sign * convertExponent * convertFraction}")
    end
end