require "big"

class Converter

    @number : String    # 与えられた2進数
    @bit : Int32        # 規格
    @bias : Int32       # 指数部のバイアス

    # コンストラクタ
    def initialize(number)
        @number = number
        @bit = 0
        @bias = 0

        if @number.size == 16       # 16-bit半精度浮動小数点規格
            puts("16-bit mode")
            @bit = 16
            @bias = 15
        elsif @number.size == 32    # 32-bit単精度浮動小数点規格
            puts("32-bit mode")
            @bit = 32
            @bias = 127
        elsif @number.size == 64    # 64-bit倍精度浮動小数点規格
            puts("64-bit mode")
            @bit = 64
            @bias = 1083
        elsif @number.size == 128   # 128-bit4倍精度浮動小数点規格
            puts("128-bit mode")
            @bit = 128
            @bias = 16383
        else
            puts("ERROR. Check the number.")
            Process.exit(0)
        end
    end

    # @numberを符号、指数部、仮数部に分割
    def split()
        ieee = ""
        if @bit == 16       # 16-bit半精度浮動小数点規格
            if ieee = /([0-9]{1})([0-9]{5})([0-9]{10})/.match(@number)  # コンストラクタの構成上きちんとtrueに振れるはず
            else
                puts("ERROR. Numerical analysis failed. Check the number.")
                Process.exit(0)
            end
        elsif @bit == 32    # 32-bit単精度浮動小数点規格
            if ieee = /([0-9]{1})([0-9]{8})([0-9]{23})/.match(@number)  # コンストラクタの構成上きちんとtrueに振れるはず
            else
                puts("ERROR. Numerical analysis failed. Check the number.")
                Process.exit(0)
            end
        elsif @bit == 64    # 64-bit倍精度浮動小数点規格
            if ieee = /([0-9]{1})([0-9]{11})([0-9]{52})/.match(@number)  # コンストラクタの構成上きちんとtrueに振れるはず
            else
                puts("ERROR. Numerical analysis failed. Check the number.")
                Process.exit(0)
            end
        elsif @bit == 128   # 128-bit4倍精度浮動小数点規格
            if ieee = /([0-9]{1})([0-9]{15})([0-9]{112})/.match(@number)  # コンストラクタの構成上きちんとtrueに振れるはず
            else
                puts("ERROR. Numerical analysis failed. Check the number.")
                Process.exit(0)
            end
        else
            puts("ERROR. The number of digits is abnormal. Check the number.")
            Process.exit(0)
        end
        ieee
    end

    # 指数部の復元
    def convertExponent()
        source = split()

        exponent_b = source[2].to_i(2) - @bias  # 指数部を10進数表現の指数値に変換する
        exponent_d = 2.0 ** exponent_b          # 指数部nに対し2のn乗で表現されているのでその形で復元
        exponent_d
    end

    def convertFraction()
        source = split()
        fraction = parse(source[3])
        fraction
    end

    def parse(source)
        sum = 1                             # IEEE754では仮数部は元の仮数のうち1は確定として記憶しないのでsumは0ではなく1にしておく
        array = source.split(//)            # 空っぽの正規表現で分割 = 1文字ずつ分割して配列に格納
        array.each_with_index do |num,i|
            divisor = 2**(i+1)
            sum += num.to_f / divisor       # 大きいほうから順番に評価。小数点の2進数→10進数変換をプログラムで実装
        end
        sum
    end

    def print()
        source = split()
        sign = 1
        sign = -1 if source[1].to_i == 1    # 符号が1ならマイナス値になる。

        puts ("復元値:#{sign * convertExponent * convertFraction}")
    end
end