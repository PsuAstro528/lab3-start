using Test, Random

@testset "Testing solution to Exercise 1" begin

@testset "Running ex1.jl" begin
   include("../ex1.jl")
end;

@testset "Testing that variables exist" begin
   @test @isdefined(multiply_matrix_vector_default)
   @test @isdefined(multiply_matrix_vector_rows_inner)
   @test @isdefined(test_mul_mat_vec)
   @test @isdefined(multiply_matrix_vector_cols_inner)
   @test @isdefined(response_1c)
   @test @isdefined(response_1d)
   @test @isdefined(response_1e)
   @test @isdefined(response_1f)
   @test @isdefined(response_1g)
   @test @isdefined(response_1h)
   @test @isdefined(response_1i)
end;

@testset "Testing that variables are not missing" begin
   @test !ismissing(response_1c)
   @test !ismissing(response_1d)
   @test !ismissing(response_1e)
   @test !ismissing(response_1f)
   @test !ismissing(response_1g)
   @test !ismissing(response_1h)
   @test !ismissing(response_1i)
end;

function make_A_b_for_test(nrows::Integer, ncols::Integer; seed::Integer = 42)
   @assert(1<=nrows<=8192)
   @assert(1<=ncols<=8192)
   Random.seed!(seed)
   A = rand(nrows,ncols)
   b = rand(ncols)
   return (A,b)    
end

@testset "Testing multiply_matrix_vector_default" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test !ismissing(multiply_matrix_vector_default(A,b))
   @test !ismissing(test_mul_mat_vec(multiply_matrix_vector_default))
   @test all(multiply_matrix_vector_default(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_default(A,b) .≈ A*b )
end;
    

@testset "Testing multiply_matrix_vector_cols_inner" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test !ismissing(multiply_matrix_vector_cols_inner(A,b))
   @test all(multiply_matrix_vector_cols_inner(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_cols_inner(A,b) .≈ A*b )
end;

@testset "Testing multiply_matrix_vector_rows_inner" begin
   (A,b) = make_A_b_for_test(3,4)     
   @test !ismissing(multiply_matrix_vector_rows_inner(A,b))
   @test all(multiply_matrix_vector_rows_inner(A,b) .≈ A*b )
   (A,b) = make_A_b_for_test(17,23)     
   @test all(multiply_matrix_vector_rows_inner(A,b) .≈ A*b )
end;

end; # Exercise 1

