defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def isOperator(str) do
    str == "+" || str == "-" || str == "*" || str == "/"
  end

  def doipop(op1, op2) do
    m = %{"+" => 0, "-" => 0, "*" => 1, "/" => 1}
    m[op1] <= m[op2]
  end

  def popStack(stack, output, op) do
    last = List.last(stack)
    if (length(stack) > 0) && (doipop(op, last)) do
      newStack = stack -- [last]
      newOutput = output ++ [last]
      popStack(newStack, newOutput, op)
    else
      %{"stack" => stack, "output" => output}
    end
  end

  def conv(item, acc) do
    case item do
      {"num", x} -> 
        %{"stack" => acc["stack"], "output" => acc["output"] ++ [x]}
      {"op", x} ->
        ps = popStack(acc["stack"], acc["output"], x)
        %{"stack" => ps["stack"] ++ [x], "output" => ps["output"]}
    end
  end

  def preToPost(item, acc) do
    if isOperator(item) do
      {operand1, tmpList} = List.pop_at(acc, -1)
      {operand2, tmpList2} = List.pop_at(tmpList, -1)
      tmpList2 ++ [item <> " " <> operand1 <> " " <> operand2]
    else
      acc ++ [item]
    end
  end

  def performOp(a, b, operator) do
    case operator do
      "+" -> a + b
      "-" -> a - b
      "/" -> a / b
      "*" -> a * b
    end
  end

  def stackCalc(item, acc) do
    if isOperator(item) do
      {operand2, tmpList} = List.pop_at(acc, -1)
      {operand1, tmpList2} = List.pop_at(tmpList, -1)
      tmpList2 ++ [performOp(operand1, operand2, item)]
    else
      acc ++ [parse_float(item)]
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    # expr
    # |> String.split(~r/\s+/)
    # |> hd
    # |> parse_float
    # |> :math.sqrt()

    #  Hint:
    #  expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{"op", "+"}, {"num", 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
    # expr
    a = String.split(expr, ~r/\s+/)
    b = Enum.map(a, 
      fn(x) -> if isOperator(x) do {"op", x} else {"num", x} end end)
    # [stack]["output"]
    c = Enum.reduce(b, %{"stack" => [], "output" => []}, &conv/2)
    d = c["output"] ++ Enum.reverse(c["stack"])
    e = Enum.reduce(d, [], &preToPost/2)
    f = hd e
    g = Enum.reverse(String.split(f, ~r/\s+/))
    hd Enum.reduce(g, [], &stackCalc/2)
  end
end
