# Jay Patel
# CS 1632- D3
require 'sinatra'

get '/' do
  # Variables
  t = params['true']
  f = params['false']
  size = params['size']
  table = params['table']
  @bad_parameter = false
  @generate_table = nil

  # Check if table is empty/generate table
  if table.nil?
    @generate_table = nil
  else
    @generate_table = 1
  end

  # Check Conditions for True Symbol
  if t.nil?
    @true_symbol = 'T'
  elsif t == ''
    @true_symbol = 'T'
  elsif t.length > 1
    @bad_parameter = true
    not_found
  else
    @true_symbol = t
  end

  # Check Conditions for false Symbol
  if f.nil?
    @false_symbol = 'F'
  elsif f == ''
    @false_symbol = 'F'
  elsif f.length > 1
    @bad_parameter = true
    not_found
  else
    @false_symbol = f
  end

  # Size Option, Conditions
  if size.nil?
    @size_table = 3
  elsif size == ''
    @size_table = 3
  else
    unless size.is_i?
      @bad_parameter = true
      not_found
    end
    @size_table = size.to_i
    if @size_table < 2
      @bad_parameter = true
      not_found
    end
  end

  # If true symbol and false symbol is same?
  if @true_symbol == @false_symbol
    @bad_parameter = true
    not_found
  end

  # Call to generate table
  gen_truth_table
  erb :main
end

def gen_truth_table
  @operator = []
  @letter

  for n in (0..((2**@size_table)-1))
    v = (("%0" + @size_table.to_s + "b") % n)
    op = v.split('')

    for i in (0..(@size_table-1))
    	@operator << op[i]
    end

    @letter = 0

    for i in (0..(op.size-1))
    	if op[i] == 1.to_s
    		@letter += 1
    	end
    end

    #AND Operation
    if @letter == op.size
    	@operator << 1
    else
    	@operator << 0
    end

    #OR Operation
    if @letter > 0
    	@operator << 1
    else
    	@operator << 0
    end

    #NAND Operation N(AND)
    if @letter == op.size
        @operator << 0
    else
        @operator << 1
    end

    #NOR Operation N(OR)
    if @letter > 0
        @operator << 0
    else
        @operator << 1
    end
	end
end

not_found do
  status 404
  erb :error_page
end

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end
