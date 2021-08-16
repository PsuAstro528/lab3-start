using Test, Random

function make_A_b_for_test(nrows::Integer, ncols::Integer; seed::Integer = 42)
   @assert(1<=nrows<=8192)
   @assert(1<=ncols<=8192)
   Random.seed!(seed)
   A = rand(nrows,ncols)
   b = rand(ncols)
   return (A,b)    
end

@testset "Testing solution to Exercise 3" begin

@testset "Testing multiply_matrix_vector_default" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test all(multiply_matrix_vector_default(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_default(A,b) .≈ A*b )
end;
    

@testset "Testing multiply_matrix_vector_cols_inner" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test all(multiply_matrix_vector_cols_inner(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_cols_inner(A,b) .≈ A*b )
end;

@testset "Testing multiply_matrix_vector_rows_inner" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test all(multiply_matrix_vector_rows_inner(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_rows_inner(A,b) .≈ A*b )
end;

end; # Exercise 3

