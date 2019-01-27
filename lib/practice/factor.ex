defmodule Practice.Factor do
  def nextDivisible(num, acc) do
    cond do
      acc > :math.sqrt(num) ->
        -1
      rem(num, acc) == 0 ->
        acc
      true ->
        nextDivisible(num, acc + 1)
    end
  end

  def factor(num) do
    a = nextDivisible(num, 2)
    if a == -1 do
      [num]
    else
      factor(a) ++ factor(div(num,  a))
    end
  end
end
