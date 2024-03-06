defmodule Mandel do
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) -> Cmplx.new(x + k * (w - 1), y - k * (h - 1)) end
    rows(width, height, trans, depth, [])
  end

  defp rows(_, 0, _, _, rows), do: rows
  defp rows(w, h, tr, depth, rows) do
    row = row(w, h, tr, depth, [])
    rows(w, h - 1, tr, depth, [row | rows])
  end

  defp row(0, _, _, _, row), do: row
  defp row(w, h, tr, depth, row) do
    c = tr.(w, h)
    res = Brot.mandelbrot(c, depth)
    color = Colour.convert(res, depth)
    row(w - 1, h, tr, depth, [color | row])
  end

  def demo(x, y, xn) do
    IO.puts("Generating small.ppm")
    small(x, y, xn)
  end

  def small(x0, y0, xn) do
    width = 3840
    height = 2160
    depth = 512  # Increase depth for more detail
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
    IO.puts("Done")
  end
end

defmodule Brot do
  # Comuptes the i value related to a complex value c

  # Given the complex number c and the maximum number of iterations m, return the value i at which
  # |zi| > 2 or 0 if it does not for any i < m i.e. it should always return a value in the range 0..(m − 1)
  def mandelbrot(c, m) do
    # z0 = 0 + 0i according to mandelbrot set
    z = Cmplx.new(0, 0)
    i = 0
    test(i, z, c, m)
  end

  defp test(i, z, c, m) do
    if Cmplx.abs(z) > 2 do
      i
    else
      if i < m do
        # z(i+1) = z(i)^2 + c according to mandelbrot set
        z1 = Cmplx.add(Cmplx.sqr(z), c)
        test(i + 1, z1, c, m)
      else
        0
      end
    end
  end
end
