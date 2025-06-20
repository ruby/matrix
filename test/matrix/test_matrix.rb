# frozen_string_literal: false
require 'test/unit'
require 'matrix'

class SubMatrix < Matrix
end

class TestMatrix < Test::Unit::TestCase
  def setup
    @m1 = Matrix[[1,2,3], [4,5,6]]
    @m2 = Matrix[[1,2,3], [4,5,6]]
    @m3 = @m1.clone
    @m4 = Matrix[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
    @n1 = Matrix[[2,3,4], [5,6,7]]
    @c1 = Matrix[[Complex(1,2), Complex(0,1), 0], [1, 2, 3]]
    @e1 = Matrix.empty(2,0)
    @e2 = Matrix.empty(0,3)
    @a3  = Matrix[[4, 1, -3], [0, 3, 7], [11, -4, 2]]
    @a5  = Matrix[[2, 0, 9, 3, 9], [8, 7, 0, 1, 9], [7, 5, 6, 6, 5], [0, 7, 8, 3, 0], [7, 8, 2, 3, 1]]
    @b3  = Matrix[[-7, 7, -10], [9, -3, -2], [-1, 3, 9]]
    @rot = Matrix[[0, -1, 0], [1, 0, 0], [0, 0, -1]]
  end

  def test_matrix
    assert_equal(1, @m1[0, 0])
    assert_equal(2, @m1[0, 1])
    assert_equal(3, @m1[0, 2])
    assert_equal(4, @m1[1, 0])
    assert_equal(5, @m1[1, 1])
    assert_equal(6, @m1[1, 2])
  end

  def test_identity
    assert_same @m1, @m1
    assert_not_same @m1, @m2
    assert_not_same @m1, @m3
    assert_not_same @m1, @m4
    assert_not_same @m1, @n1
  end

  def test_equality
    assert_equal @m1, @m1
    assert_equal @m1, @m2
    assert_equal @m1, @m3
    assert_equal @m1, @m4
    assert_not_equal @m1, @n1
  end

  def test_hash_equality
    assert @m1.eql?(@m1)
    assert @m1.eql?(@m2)
    assert @m1.eql?(@m3)
    assert !@m1.eql?(@m4)
    assert !@m1.eql?(@n1)

    hash = { @m1 => :value }
    assert hash.key?(@m1)
    assert hash.key?(@m2)
    assert hash.key?(@m3)
    assert !hash.key?(@m4)
    assert !hash.key?(@n1)
  end

  def test_hash
    assert_equal @m1.hash, @m1.hash
    assert_equal @m1.hash, @m2.hash
    assert_equal @m1.hash, @m3.hash
  end

  def test_uplus
    assert_equal(@m1, +@m1)
  end

  def test_negate
    assert_equal(Matrix[[-1, -2, -3], [-4, -5, -6]], -@m1)
    assert_equal(@m1, -(-@m1))
  end

  def test_rank
    [
      [[0]],
      [[0], [0]],
      [[0, 0], [0, 0]],
      [[0, 0], [0, 0], [0, 0]],
      [[0, 0, 0]],
      [[0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
    ].each do |rows|
      assert_equal 0, Matrix[*rows].rank
    end

    [
      [[1], [0]],
      [[1, 0], [0, 0]],
      [[1, 0], [1, 0]],
      [[0, 0], [1, 0]],
      [[1, 0], [0, 0], [0, 0]],
      [[0, 0], [1, 0], [0, 0]],
      [[0, 0], [0, 0], [1, 0]],
      [[1, 0], [1, 0], [0, 0]],
      [[0, 0], [1, 0], [1, 0]],
      [[1, 0], [1, 0], [1, 0]],
      [[1, 0, 0]],
      [[1, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [1, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [1, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [1, 0, 0], [0, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [0, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [1, 0, 0], [0, 0, 0]],
      [[1, 0, 0], [0, 0, 0], [1, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [0, 0, 0], [1, 0, 0]],
      [[1, 0, 0], [1, 0, 0], [1, 0, 0], [1, 0, 0]],

      [[1]],
      [[1], [1]],
      [[1, 1]],
      [[1, 1], [1, 1]],
      [[1, 1], [1, 1], [1, 1]],
      [[1, 1, 1]],
      [[1, 1, 1], [1, 1, 1]],
      [[1, 1, 1], [1, 1, 1], [1, 1, 1]],
      [[1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]],
    ].each do |rows|
      matrix = Matrix[*rows]
      assert_equal 1, matrix.rank
      assert_equal 1, matrix.transpose.rank
    end

    [
      [[1, 0], [0, 1]],
      [[1, 0], [0, 1], [0, 0]],
      [[1, 0], [0, 1], [0, 1]],
      [[1, 0], [0, 1], [1, 1]],
      [[1, 0, 0], [0, 1, 0]],
      [[1, 0, 0], [0, 0, 1]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[1, 0, 0], [0, 0, 1], [0, 0, 0]],

      [[1, 0, 0], [0, 0, 0], [0, 1, 0]],
      [[1, 0, 0], [0, 0, 0], [0, 0, 1]],

      [[1, 0], [1, 1]],
      [[1, 2], [1, 1]],
      [[1, 2], [0, 1], [1, 1]],
    ].each do |rows|
      m = Matrix[*rows]
      assert_equal 2, m.rank
      assert_equal 2, m.transpose.rank
    end

    [
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[1, 1, 0], [0, 1, 1], [1, 0, 1]],
      [[1, 1, 0], [0, 1, 1], [1, 0, 1]],
      [[1, 1, 0], [0, 1, 1], [1, 0, 1], [0, 0, 0]],
      [[1, 1, 0], [0, 1, 1], [1, 0, 1], [1, 1, 1]],
      [[1, 1, 1], [1, 1, 2], [1, 3, 1], [4, 1, 1]],
    ].each do |rows|
      m = Matrix[*rows]
      assert_equal 3, m.rank
      assert_equal 3, m.transpose.rank
    end
  end

  def test_inverse
    assert_equal(Matrix.empty(0, 0), Matrix.empty.inverse)
    assert_equal(Matrix[[-1, 1], [0, -1]], Matrix[[-1, -1], [0, -1]].inverse)
    assert_raise(ExceptionForMatrix::ErrDimensionMismatch) { @m1.inverse }
  end

  def test_determinant
    assert_equal(0, Matrix[[0,0],[0,0]].determinant)
    assert_equal(45, Matrix[[7,6], [3,9]].determinant)
    assert_equal(-18, Matrix[[2,0,1],[0,-2,2],[1,2,3]].determinant)
    assert_equal(-7, Matrix[[0,0,1],[0,7,6],[1,3,9]].determinant)
    assert_equal(42, Matrix[[7,0,1,0,12],[8,1,1,9,1],[4,0,0,-7,17],[-1,0,0,-4,8],[10,1,1,8,6]].determinant)
  end

  def test_new_matrix
    assert_raise(TypeError) { Matrix[Object.new] }
    o = Object.new
    def o.to_ary; [1,2,3]; end
    assert_equal(@m1, Matrix[o, [4,5,6]])
  end

  def test_round
    a = Matrix[[1.0111, 2.32320, 3.04343], [4.81, 5.0, 6.997]]
    b = Matrix[[1.01, 2.32, 3.04], [4.81, 5.0, 7.0]]
    assert_equal(a.round(2), b)
  end

  def test_rows
    assert_equal(@m1, Matrix.rows([[1, 2, 3], [4, 5, 6]]))
  end

  def test_rows_copy
    rows1 = [[1], [1]]
    rows2 = [[1], [1]]

    m1 = Matrix.rows(rows1, copy = false)
    m2 = Matrix.rows(rows2, copy = true)

    rows1.uniq!
    rows2.uniq!

    assert_equal([[1]],      m1.to_a)
    assert_equal([[1], [1]], m2.to_a)
  end

  def test_to_matrix
    assert @m1.equal? @m1.to_matrix
  end

  def test_columns
    assert_equal(@m1, Matrix.columns([[1, 4], [2, 5], [3, 6]]))
  end

  def test_diagonal
    assert_equal(Matrix.empty(0, 0), Matrix.diagonal( ))
    assert_equal(Matrix[[3,0,0],[0,2,0],[0,0,1]], Matrix.diagonal(3, 2, 1))
    assert_equal(Matrix[[4,0,0,0],[0,3,0,0],[0,0,2,0],[0,0,0,1]], Matrix.diagonal(4, 3, 2, 1))
  end

  def test_scalar
    assert_equal(Matrix.empty(0, 0), Matrix.scalar(0, 1))
    assert_equal(Matrix[[2,0,0],[0,2,0],[0,0,2]], Matrix.scalar(3, 2))
    assert_equal(Matrix[[2,0,0,0],[0,2,0,0],[0,0,2,0],[0,0,0,2]], Matrix.scalar(4, 2))
  end

  def test_identity2
    assert_equal(Matrix[[1,0,0],[0,1,0],[0,0,1]], Matrix.identity(3))
    assert_equal(Matrix[[1,0,0],[0,1,0],[0,0,1]], Matrix.unit(3))
    assert_equal(Matrix[[1,0,0],[0,1,0],[0,0,1]], Matrix.I(3))
    assert_equal(Matrix[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]], Matrix.identity(4))
  end

  def test_zero
    assert_equal(Matrix[[0,0,0],[0,0,0],[0,0,0]], Matrix.zero(3))
    assert_equal(Matrix[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], Matrix.zero(4))
    assert_equal(Matrix[[0]], Matrix.zero(1))
  end

  def test_row_vector
    assert_equal(Matrix[[1,2,3,4]], Matrix.row_vector([1,2,3,4]))
  end

  def test_column_vector
    assert_equal(Matrix[[1],[2],[3],[4]], Matrix.column_vector([1,2,3,4]))
  end

  def test_empty
    m = Matrix.empty(2, 0)
    assert_equal(Matrix[ [], [] ], m)
    n = Matrix.empty(0, 3)
    assert_equal(Matrix.columns([ [], [], [] ]), n)
    assert_equal(Matrix[[0, 0, 0], [0, 0, 0]], m * n)
  end

  def test_row
    assert_equal(Vector[1, 2, 3], @m1.row(0))
    assert_equal(Vector[4, 5, 6], @m1.row(1))
    a = []; @m1.row(0) {|x| a << x }
    assert_equal([1, 2, 3], a)
  end

  def test_column
    assert_equal(Vector[1, 4], @m1.column(0))
    assert_equal(Vector[2, 5], @m1.column(1))
    assert_equal(Vector[3, 6], @m1.column(2))
    a = []; @m1.column(0) {|x| a << x }
    assert_equal([1, 4], a)
  end

  def test_collect
    m1 = Matrix.zero(2,2)
    m2 = Matrix.build(3,4){|row, col| 1}

    assert_equal(Matrix[[5, 5, 5, 5], [5, 5, 5, 5], [5, 5, 5, 5]], m2.collect{|e| e * 5})
    assert_equal(Matrix[[7, 0],[0, 7]], m1.collect(:diagonal){|e| e + 7})
    assert_equal(Matrix[[0, 5],[5, 0]], m1.collect(:off_diagonal){|e| e + 5})
    assert_equal(Matrix[[8, 1, 1, 1], [8, 8, 1, 1], [8, 8, 8, 1]], m2.collect(:lower){|e| e + 7})
    assert_equal(Matrix[[1, 1, 1, 1], [-11, 1, 1, 1], [-11, -11, 1, 1]], m2.collect(:strict_lower){|e| e - 12})
    assert_equal(Matrix[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], m2.collect(:strict_upper){|e| e ** 2})
    assert_equal(Matrix[[-1, -1, -1, -1], [1, -1, -1, -1], [1, 1, -1, -1]], m2.collect(:upper){|e| -e})
    assert_raise(ArgumentError) {m1.collect(:test){|e| e + 7}}
    assert_not_equal(m2, m2.collect {|e| e * 2 })
  end

  def test_minor
    assert_equal(Matrix[[1, 2], [4, 5]], @m1.minor(0..1, 0..1))
    assert_equal(Matrix[[2], [5]], @m1.minor(0..1, 1..1))
    assert_equal(Matrix[[4, 5]], @m1.minor(1..1, 0..1))
    assert_equal(Matrix[[1, 2], [4, 5]], @m1.minor(0, 2, 0, 2))
    assert_equal(Matrix[[4, 5]], @m1.minor(1, 1, 0, 2))
    assert_equal(Matrix[[2], [5]], @m1.minor(0, 2, 1, 1))
    assert_raise(ArgumentError) { @m1.minor(0) }
  end

  def test_first_minor
    assert_equal(Matrix.empty(0, 0), Matrix[[1]].first_minor(0, 0))
    assert_equal(Matrix.empty(0, 2), Matrix[[1, 4, 2]].first_minor(0, 1))
    assert_equal(Matrix[[1, 3]], @m1.first_minor(1, 1))
    assert_equal(Matrix[[4, 6]], @m1.first_minor(0, 1))
    assert_equal(Matrix[[1, 2]], @m1.first_minor(1, 2))
    assert_raise(RuntimeError) { Matrix.empty(0, 0).first_minor(0, 0) }
    assert_raise(ArgumentError) { @m1.first_minor(4, 0) }
    assert_raise(ArgumentError) { @m1.first_minor(0, -1) }
    assert_raise(ArgumentError) { @m1.first_minor(-1, 4) }
  end

  def test_cofactor
    assert_equal(1, Matrix[[1]].cofactor(0, 0))
    assert_equal(9, Matrix[[7,6],[3,9]].cofactor(0, 0))
    assert_equal(0, Matrix[[0,0],[0,0]].cofactor(0, 0))
    assert_equal(3, Matrix[[0,0,1],[0,7,6],[1,3,9]].cofactor(1, 0))
    assert_equal(-21, Matrix[[7,0,1,0,12],[8,1,1,9,1],[4,0,0,-7,17],[-1,0,0,-4,8],[10,1,1,8,6]].cofactor(2, 3))
    assert_raise(RuntimeError) { Matrix.empty(0, 0).cofactor(0, 0) }
    assert_raise(ArgumentError) { Matrix[[0,0],[0,0]].cofactor(-1, 4) }
    assert_raise(ExceptionForMatrix::ErrDimensionMismatch) { Matrix[[2,0,1],[0,-2,2]].cofactor(0, 0) }
  end

  def test_adjugate
    assert_equal(Matrix.empty, Matrix.empty.adjugate)
    assert_equal(Matrix[[1]], Matrix[[5]].adjugate)
    assert_equal(Matrix[[9,-6],[-3,7]], Matrix[[7,6],[3,9]].adjugate)
    assert_equal(Matrix[[45,3,-7],[6,-1,0],[-7,0,0]], Matrix[[0,0,1],[0,7,6],[1,3,9]].adjugate)
    assert_equal(Matrix.identity(5), (@a5.adjugate * @a5) / @a5.det)
    assert_equal(Matrix.I(3), Matrix.I(3).adjugate)
    assert_equal((@a3 * @b3).adjugate, @b3.adjugate * @a3.adjugate)
    assert_equal(4**(@a3.row_count-1) * @a3.adjugate, (4 * @a3).adjugate)
    assert_raise(ExceptionForMatrix::ErrDimensionMismatch) { @m1.adjugate }
  end

  def test_laplace_expansion
    assert_equal(1, Matrix[[1]].laplace_expansion(row: 0))
    assert_equal(45, Matrix[[7,6], [3,9]].laplace_expansion(row: 1))
    assert_equal(0, Matrix[[0,0],[0,0]].laplace_expansion(column: 0))
    assert_equal(-7, Matrix[[0,0,1],[0,7,6],[1,3,9]].laplace_expansion(column: 2))

    assert_equal(Vector[3, -2], Matrix[[Vector[1, 0], Vector[0, 1]], [2, 3]].laplace_expansion(row: 0))

    assert_raise(ExceptionForMatrix::ErrDimensionMismatch) { @m1.laplace_expansion(row: 1) }
    assert_raise(ArgumentError) { Matrix[[7,6], [3,9]].laplace_expansion() }
    assert_raise(ArgumentError) { Matrix[[7,6], [3,9]].laplace_expansion(foo: 1) }
    assert_raise(ArgumentError) { Matrix[[7,6], [3,9]].laplace_expansion(row: 1, column: 1) }
    assert_raise(ArgumentError) { Matrix[[7,6], [3,9]].laplace_expansion(row: 2) }
    assert_raise(ArgumentError) { Matrix[[0,0,1],[0,7,6],[1,3,9]].laplace_expansion(column: -1) }

    assert_raise(RuntimeError) { Matrix.empty(0, 0).laplace_expansion(row: 0) }
  end

  def test_regular?
    assert(Matrix[[1, 0], [0, 1]].regular?)
    assert(Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]].regular?)
    assert(!Matrix[[1, 0, 0], [0, 0, 1], [0, 0, 1]].regular?)
  end

  def test_singular?
    assert(!Matrix[[1, 0], [0, 1]].singular?)
    assert(!Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]].singular?)
    assert(Matrix[[1, 0, 0], [0, 0, 1], [0, 0, 1]].singular?)
  end

  def test_square?
    assert(Matrix[[1, 0], [0, 1]].square?)
    assert(Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]].square?)
    assert(Matrix[[1, 0, 0], [0, 0, 1], [0, 0, 1]].square?)
    assert(!Matrix[[1, 0, 0], [0, 1, 0]].square?)
  end

  def test_mul
    assert_equal(Matrix[[2,4],[6,8]], Matrix[[2,4],[6,8]] * Matrix.I(2))
    assert_equal(Matrix[[4,8],[12,16]], Matrix[[2,4],[6,8]] * 2)
    assert_equal(Matrix[[4,8],[12,16]], 2 * Matrix[[2,4],[6,8]])
    assert_equal(Matrix[[14,32],[32,77]], @m1 * @m1.transpose)
    assert_equal(Matrix[[17,22,27],[22,29,36],[27,36,45]], @m1.transpose * @m1)
    assert_equal(Vector[14,32], @m1 * Vector[1,2,3])
    o = Object.new
    def o.coerce(m)
      [m, m.transpose]
    end
    assert_equal(Matrix[[14,32],[32,77]], @m1 * o)
  end

  def test_add
    assert_equal(Matrix[[6,0],[-4,12]], Matrix.scalar(2,5) + Matrix[[1,0],[-4,7]])
    assert_equal(Matrix[[3,5,7],[9,11,13]], @m1 + @n1)
    assert_equal(Matrix[[3,5,7],[9,11,13]], @n1 + @m1)
    assert_equal(Matrix[[2],[4],[6]], Matrix[[1],[2],[3]] + Vector[1,2,3])
    assert_raise(Matrix::ErrOperationNotDefined) { @m1 + 1 }
    o = Object.new
    def o.coerce(m)
      [m, m]
    end
    assert_equal(Matrix[[2,4,6],[8,10,12]], @m1 + o)
  end

  def test_sub
    assert_equal(Matrix[[4,0],[4,-2]], Matrix.scalar(2,5) - Matrix[[1,0],[-4,7]])
    assert_equal(Matrix[[-1,-1,-1],[-1,-1,-1]], @m1 - @n1)
    assert_equal(Matrix[[1,1,1],[1,1,1]], @n1 - @m1)
    assert_equal(Matrix[[0],[0],[0]], Matrix[[1],[2],[3]] - Vector[1,2,3])
    assert_raise(Matrix::ErrOperationNotDefined) { @m1 - 1 }
    o = Object.new
    def o.coerce(m)
      [m, m]
    end
    assert_equal(Matrix[[0,0,0],[0,0,0]], @m1 - o)
  end

  def test_div
    assert_equal(Matrix[[0,1,1],[2,2,3]], @m1 / 2)
    assert_equal(Matrix[[1,1],[1,1]], Matrix[[2,2],[2,2]] / Matrix.scalar(2,2))
    o = Object.new
    def o.coerce(m)
      [m, Matrix.scalar(2,2)]
    end
    assert_equal(Matrix[[1,1],[1,1]], Matrix[[2,2],[2,2]] / o)
  end

  def test_hadamard_product
    assert_equal(Matrix[[1,4], [9,16]], Matrix[[1,2], [3,4]].hadamard_product(Matrix[[1,2], [3,4]]))
    assert_equal(Matrix[[2, 6, 12], [20, 30, 42]], @m1.hadamard_product(@n1))
    o = Object.new
    def o.to_matrix
      Matrix[[1, 2, 3], [-1, 0, 1]]
    end
    assert_equal(Matrix[[1, 4, 9], [-4, 0, 6]], @m1.hadamard_product(o))
    e = Matrix.empty(3, 0)
    assert_equal(e, e.hadamard_product(e))
    e = Matrix.empty(0, 3)
    assert_equal(e, e.hadamard_product(e))
  end

  def test_exp
    assert_equal(Matrix[[67,96],[48,99]], Matrix[[7,6],[3,9]] ** 2)
    assert_equal(Matrix.I(5), Matrix.I(5) ** -1)
    assert_raise(Matrix::ErrOperationNotDefined) { Matrix.I(5) ** Object.new }

    m = Matrix[[0,2],[1,0]]
    exp = 0b11101000
    assert_equal(Matrix.scalar(2, 1 << (exp/2)), m ** exp)
    exp = 0b11101001
    assert_equal(Matrix[[0, 2 << (exp/2)], [1 << (exp/2), 0]], m ** exp)
  end

  def test_det
    assert_equal(Matrix.instance_method(:determinant), Matrix.instance_method(:det))
  end

  def test_rank2
    assert_equal(2, Matrix[[7,6],[3,9]].rank)
    assert_equal(0, Matrix[[0,0],[0,0]].rank)
    assert_equal(3, Matrix[[0,0,1],[0,7,6],[1,3,9]].rank)
    assert_equal(1, Matrix[[0,1],[0,1],[0,1]].rank)
    assert_equal(2, @m1.rank)
  end

  def test_trace
    assert_equal(1+5+9, Matrix[[1,2,3],[4,5,6],[7,8,9]].trace)
  end

  def test_transpose
    assert_equal(Matrix[[1,4],[2,5],[3,6]], @m1.transpose)
  end

  def test_conjugate
    assert_equal(Matrix[[Complex(1,-2), Complex(0,-1), 0], [1, 2, 3]], @c1.conjugate)
  end

  def test_eigensystem
    m = Matrix[[1, 2], [3, 4]]
    v, d, v_inv = m.eigensystem
    assert(d.diagonal?)
    assert_equal(v.inv, v_inv)
    assert_equal((v * d * v_inv).round(5), m)
  end

  def test_imaginary
    assert_equal(Matrix[[2, 1, 0], [0, 0, 0]], @c1.imaginary)
  end

  def test_lup
    m = Matrix[[1, 2], [3, 4]]
    l, u, p = m.lup
    assert(l.lower_triangular?)
    assert(u.upper_triangular?)
    assert(p.permutation?)
    assert(l * u == p * m)
    assert_equal(m.lup.solve([2, 5]), Vector[1, Rational(1,2)])
  end

  def test_real
    assert_equal(Matrix[[1, 0, 0], [1, 2, 3]], @c1.real)
  end

  def test_rect
    assert_equal([Matrix[[1, 0, 0], [1, 2, 3]], Matrix[[2, 1, 0], [0, 0, 0]]], @c1.rect)
  end

  def test_row_vectors
    assert_equal([Vector[1,2,3], Vector[4,5,6]], @m1.row_vectors)
  end

  def test_column_vectors
    assert_equal([Vector[1,4], Vector[2,5], Vector[3,6]], @m1.column_vectors)
  end

  def test_to_s
    assert_equal("Matrix[[1, 2, 3], [4, 5, 6]]", @m1.to_s)
    assert_equal("Matrix.empty(0, 0)", Matrix[].to_s)
    assert_equal("Matrix.empty(1, 0)", Matrix[[]].to_s)
  end

  def test_inspect
    assert_equal("Matrix[[1, 2, 3], [4, 5, 6]]", @m1.inspect)
    assert_equal("Matrix.empty(0, 0)", Matrix[].inspect)
    assert_equal("Matrix.empty(1, 0)", Matrix[[]].inspect)
  end

  def test_scalar_add
    s1 = @m1.coerce(1).first
    assert_equal(Matrix[[1]], (s1 + 0) * Matrix[[1]])
    assert_raise(Matrix::ErrOperationNotDefined) { s1 + Vector[0] }
    assert_raise(Matrix::ErrOperationNotDefined) { s1 + Matrix[[0]] }
    o = Object.new
    def o.coerce(x)
      [1, 1]
    end
    assert_equal(2, s1 + o)
  end

  def test_scalar_sub
    s1 = @m1.coerce(1).first
    assert_equal(Matrix[[1]], (s1 - 0) * Matrix[[1]])
    assert_raise(Matrix::ErrOperationNotDefined) { s1 - Vector[0] }
    assert_raise(Matrix::ErrOperationNotDefined) { s1 - Matrix[[0]] }
    o = Object.new
    def o.coerce(x)
      [1, 1]
    end
    assert_equal(0, s1 - o)
  end

  def test_scalar_mul
    s1 = @m1.coerce(1).first
    assert_equal(Matrix[[1]], (s1 * 1) * Matrix[[1]])
    assert_equal(Vector[2], s1 * Vector[2])
    assert_equal(Matrix[[2]], s1 * Matrix[[2]])
    o = Object.new
    def o.coerce(x)
      [1, 1]
    end
    assert_equal(1, s1 * o)
  end

  def test_scalar_div
    s1 = @m1.coerce(1).first
    assert_equal(Matrix[[1]], (s1 / 1) * Matrix[[1]])
    assert_raise(Matrix::ErrOperationNotDefined) { s1 / Vector[0] }
    assert_equal(Matrix[[Rational(1,2)]], s1 / Matrix[[2]])
    o = Object.new
    def o.coerce(x)
      [1, 1]
    end
    assert_equal(1, s1 / o)
  end

  def test_scalar_pow
    s1 = @m1.coerce(1).first
    assert_equal(Matrix[[1]], (s1 ** 1) * Matrix[[1]])
    assert_raise(Matrix::ErrOperationNotDefined) { s1 ** Vector[0] }
    assert_raise(Matrix::ErrOperationNotImplemented) { s1 ** Matrix[[1]] }
    o = Object.new
    def o.coerce(x)
      [1, 1]
    end
    assert_equal(1, s1 ** o)
  end

  def test_abs
    s1 = @a3.abs
    assert_equal(s1, Matrix[[4, 1, 3], [0, 3, 7], [11, 4, 2]])
  end

  def test_hstack
    assert_equal Matrix[[1,2,3,2,3,4,1,2,3], [4,5,6,5,6,7,4,5,6]],
      @m1.hstack(@n1, @m1)
    # Error checking:
    assert_raise(TypeError) { @m1.hstack(42) }
    assert_raise(TypeError) { Matrix.hstack(42, @m1) }
    assert_raise(Matrix::ErrDimensionMismatch) { @m1.hstack(Matrix.identity(3)) }
    assert_raise(Matrix::ErrDimensionMismatch) { @e1.hstack(@e2) }
    # Corner cases:
    assert_equal @m1, @m1.hstack
    assert_equal @e1, @e1.hstack(@e1)
    assert_equal Matrix.empty(0,6), @e2.hstack(@e2)
    assert_equal SubMatrix, SubMatrix.hstack(@e1).class
    # From Vectors:
    assert_equal Matrix[[1, 3],[2, 4]], Matrix.hstack(Vector[1,2], Vector[3, 4])
  end

  def test_vstack
    assert_equal Matrix[[1,2,3], [4,5,6], [2,3,4], [5,6,7], [1,2,3], [4,5,6]],
      @m1.vstack(@n1, @m1)
    # Error checking:
    assert_raise(TypeError) { @m1.vstack(42) }
    assert_raise(TypeError) { Matrix.vstack(42, @m1) }
    assert_raise(Matrix::ErrDimensionMismatch) { @m1.vstack(Matrix.identity(2)) }
    assert_raise(Matrix::ErrDimensionMismatch) { @e1.vstack(@e2) }
    # Corner cases:
    assert_equal @m1, @m1.vstack
    assert_equal Matrix.empty(4,0), @e1.vstack(@e1)
    assert_equal @e2, @e2.vstack(@e2)
    assert_equal SubMatrix, SubMatrix.vstack(@e1).class
    # From Vectors:
    assert_equal Matrix[[1],[2],[3]], Matrix.vstack(Vector[1,2], Vector[3])
  end

  def test_combine
    x = Matrix[[6, 6], [4, 4]]
    y = Matrix[[1, 2], [3, 4]]
    assert_equal Matrix[[5, 4], [1, 0]], Matrix.combine(x, y) {|a, b| a - b}
    assert_equal Matrix[[5, 4], [1, 0]], x.combine(y) {|a, b| a - b}
    # Without block
    assert_equal Matrix[[5, 4], [1, 0]], Matrix.combine(x, y).each {|a, b| a - b}
    # With vectors
    assert_equal Matrix[[111], [222]], Matrix.combine(Matrix[[1], [2]], Vector[10,20], Vector[100,200], &:sum)
    # Basic checks
    assert_raise(Matrix::ErrDimensionMismatch) { @m1.combine(x) { raise } }
    # Edge cases
    assert_equal Matrix.empty, Matrix.combine{ raise }
    assert_equal Matrix.empty(3,0), Matrix.combine(Matrix.empty(3,0), Matrix.empty(3,0)) { raise }
    assert_equal Matrix.empty(0,3), Matrix.combine(Matrix.empty(0,3), Matrix.empty(0,3)) { raise }
  end

  def test_set_element
    src = Matrix[
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, 11, 12],
    ]
    rows = {
      range:   [1..2, 1...3, 1..-1, -2..2, 1.., 1..., -2.., -2...],
      int:     [2, -1],
      invalid: [-4, 4, -4..2, 2..-4, 0...0, 2..0, -4..],
    }
    columns = {
      range:   [2..3, 2...4, 2..-1, -2..3, 2.., 2..., -2..., -2..],
      int:     [3, -1],
      invalid: [-5, 5, -5..2, 2..-5, 0...0, -5..],
    }
    values = {
      element: 42,
      matrix:  Matrix[[20, 21], [22, 23]],
      vector:  Vector[30, 31],
      row:     Matrix[[60, 61]],
      column:  Matrix[[50], [51]],
      mismatched_matrix: Matrix.identity(3),
      mismatched_vector: Vector[0, 1, 2, 3],
    }
    solutions = {
      [:int, :int] => {
        element: Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 42]],
      },
      [:range , :int] => {
        element: Matrix[[1, 2, 3, 4], [5, 6, 7, 42], [9, 10, 11, 42]],
        column:  Matrix[[1, 2, 3, 4], [5, 6, 7, 50], [9, 10, 11, 51]],
        vector:  Matrix[[1, 2, 3, 4], [5, 6, 7, 30], [9, 10, 11, 31]],
      },
      [:int, :range] => {
        element: Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 42, 42]],
        row:     Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 60, 61]],
        vector:  Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 30, 31]],
      },
      [:range , :range] => {
        element: Matrix[[1, 2, 3, 4], [5, 6, 42, 42], [9, 10, 42, 42]],
        matrix:  Matrix[[1, 2, 3, 4], [5, 6, 20, 21], [9, 10, 22, 23]],
      },
    }
    solutions.default = Hash.new(IndexError)

    rows.each do |row_style, row_arguments|
      row_arguments.each do |row_argument|
        columns.each do |column_style, column_arguments|
          column_arguments.each do |column_argument|
            values.each do |value_type, value|
              expected = solutions[[row_style, column_style]][value_type] || Matrix::ErrDimensionMismatch

              result = src.clone
              begin
                result[row_argument, column_argument] = value
                assert_equal expected, result,
                  "m[#{row_argument.inspect}][#{column_argument.inspect}] = #{value.inspect} failed"
              rescue Exception => e
                raise if e.class != expected
              end
            end
          end
        end
      end
    end
  end

  def test_map!
    m1 = Matrix.zero(2,2)
    m2 = Matrix.build(3,4){|row, col| 1}
    m3 = Matrix.zero(3,5).freeze
    m4 = Matrix.empty.freeze

    assert_equal Matrix[[5, 5, 5, 5], [5, 5, 5, 5], [5, 5, 5, 5]], m2.map!{|e| e * 5}
    assert_equal Matrix[[7, 0],[0, 7]], m1.map!(:diagonal){|e| e + 7}
    assert_equal Matrix[[7, 5],[5, 7]], m1.map!(:off_diagonal){|e| e + 5}
    assert_equal Matrix[[12, 5, 5, 5], [12, 12, 5, 5], [12, 12, 12, 5]], m2.map!(:lower){|e| e + 7}
    assert_equal Matrix[[12, 5, 5, 5], [0, 12, 5, 5], [0, 0, 12, 5]], m2.map!(:strict_lower){|e| e - 12}
    assert_equal Matrix[[12, 25, 25, 25], [0, 12, 25, 25], [0, 0, 12, 25]], m2.map!(:strict_upper){|e| e ** 2}
    assert_equal Matrix[[-12, -25, -25, -25], [0, -12, -25, -25], [0, 0, -12, -25]], m2.map!(:upper){|e| -e}
    assert_equal m1, m1.map!{|e| e ** 2 }
    assert_equal m2, m2.map!(:lower){ |e| e - 3 }
    assert_raise(ArgumentError) {m1.map!(:test){|e| e + 7}}
    assert_raise(FrozenError) { m3.map!{|e| e * 2} }
    assert_raise(FrozenError) { m4.map!{} }
  end

  def test_freeze
    m = Matrix[[1, 2, 3],[4, 5, 6]]
    f = m.freeze
    assert_equal true, f.frozen?
    assert m.equal?(f)
    assert m.equal?(f.freeze)
    assert_raise(FrozenError){ m[0, 1] = 56 }
    assert_equal m.dup, m
  end

  def test_clone
    a = Matrix[[4]]
    def a.foo
      42
    end

    m = a.clone
    m[0, 0] = 2
    assert_equal a, m * 2
    assert_equal 42, m.foo

    a.freeze
    m = a.clone
    assert m.frozen?
    assert_equal 42, m.foo
  end

  def test_dup
    a = Matrix[[4]]
    def a.foo
      42
    end
    a.freeze

    m = a.dup
    m[0, 0] = 2
    assert_equal a, m * 2
    assert !m.respond_to?(:foo)
  end

  def test_eigenvalues_and_eigenvectors_symmetric
    m = Matrix[
      [8, 1],
      [1, 8]
    ]
    values = m.eigensystem.eigenvalues
    assert_in_epsilon(7.0, values[0])
    assert_in_epsilon(9.0, values[1])
    vectors = m.eigensystem.eigenvectors
    assert_in_epsilon(-vectors[0][0], vectors[0][1])
    assert_in_epsilon(vectors[1][0], vectors[1][1])
  end

  def test_eigenvalues_and_eigenvectors_nonsymmetric
    m = Matrix[
      [8, 1],
      [4, 5]
    ]
    values = m.eigensystem.eigenvalues
    assert_in_epsilon(9.0, values[0])
    assert_in_epsilon(4.0, values[1])
    vectors = m.eigensystem.eigenvectors
    assert_in_epsilon(vectors[0][0], vectors[0][1])
    assert_in_epsilon(-4 * vectors[1][0], vectors[1][1])
  end

  def test_unitary?
    assert_equal true, @rot.unitary?
    assert_equal true, ((0+1i) * @rot).unitary?
    assert_equal false, @a3.unitary?
    assert_raise(Matrix::ErrDimensionMismatch) { @m1.unitary? }
  end

  def test_orthogonal
    assert_equal true, @rot.orthogonal?
    assert_equal false, ((0+1i) * @rot).orthogonal?
    assert_equal false, @a3.orthogonal?
    assert_raise(Matrix::ErrDimensionMismatch) { @m1.orthogonal? }
  end

  def test_adjoint
    assert_equal(Matrix[[(1-2i), 1], [(0-1i), 2], [0, 3]], @c1.adjoint)
    assert_equal(Matrix.empty(0,2), @e1.adjoint)
  end

  def test_ractor
    assert_ractor(<<~RUBY, require: 'matrix')
      class Ractor
        alias value take
      end unless Ractor.method_defined? :value # compat with Ruby 3.4 and olders

      obj1 = Matrix[[1, 2], [3, 4]].freeze

      obj2 = Ractor.new obj1 do |obj|
        obj
      end.value
      assert_same obj1, obj2
    RUBY
  end if defined?(Ractor)

  def test_rotate_with_symbol
    assert_equal(Matrix[[4, 1], [5, 2], [6, 3]], @m1.rotate_entries)
    assert_equal(@m1.rotate_entries, @m1.rotate_entries(:clockwise))
    assert_equal(Matrix[[4, 1], [5, 2], [6, 3]],
                 @m1.rotate_entries(:clockwise))
    assert_equal(Matrix[[3, 6], [2, 5], [1, 4]],
                 @m1.rotate_entries(:counter_clockwise))
    assert_equal(Matrix[[6, 5, 4], [3, 2, 1]],
                 @m1.rotate_entries(:half_turn))
    assert_equal(Matrix[[6, 5, 4], [3, 2, 1]],
                 @m1.rotate_entries(:half_turn))
    assert_equal(Matrix.empty(0,2),
                 @e1.rotate_entries(:clockwise))
    assert_equal(Matrix.empty(0,2),
                 @e1.rotate_entries(:counter_clockwise))
    assert_equal(Matrix.empty(2,0),
                 @e1.rotate_entries(:half_turn))
    assert_equal(Matrix.empty(0,3),
                 @e2.rotate_entries(:half_turn))
  end

  def test_rotate_with_numeric
    assert_equal(Matrix[[4, 1], [5, 2], [6, 3]],
                 @m1.rotate_entries(1))
    assert_equal(@m2.rotate_entries(:half_turn),
                 @m2.rotate_entries(2))
    assert_equal(@m2.rotate_entries(:half_turn),
                 @m1.rotate_entries(2))
    assert_equal(@m1.rotate_entries(:counter_clockwise),
                 @m1.rotate_entries(3))
    assert_equal(@m1,
                 @m1.rotate_entries(4))
    assert_equal(@m1,
                 @m1.rotate_entries(4))
    assert_not_same(@m1,
                    @m1.rotate_entries(4))
    assert_equal(@m1.rotate_entries(:clockwise),
                 @m1.rotate_entries(5))
    assert_equal(Matrix.empty(0,2),
                 @e1.rotate_entries(1))
    assert_equal(@e2,
                 @e2.rotate_entries(2))
    assert_equal(@e2.rotate_entries(1),
                 @e2.rotate_entries(3))
    assert_equal(@e2.rotate_entries(:counter_clockwise),
                 @e2.rotate_entries(-1))
    assert_equal(@m1.rotate_entries(:counter_clockwise),
                 @m1.rotate_entries(-1))
    assert_equal(Matrix[[6, 5, 4], [3, 2, 1]],
                 @m1.rotate_entries(-2))
    assert_equal(@m1,
                 @m1.rotate_entries(-4))
    assert_equal(@m1.rotate_entries(-1),
                 @m1.rotate_entries(-5))
  end
end
