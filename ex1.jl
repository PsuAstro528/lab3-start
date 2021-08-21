### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 06e16a4a-fdc3-11eb-0462-d3dce4d54728
begin
	using Random, PlutoTest, BenchmarkTools
	using PlutoUI, PlutoTeachingTools
	using Plots
end

# ╔═╡ 6856a387-a359-45ae-a70a-7eb6665097bd
md"""
# Astro 528, Lab 3, Exercise 1
# Dense Matrix-Vector Multiply

Many problems involve performing linear algebra. Fortunately, there are excellent libraries that make use of clever algorithms to perform linear algebra efficiently and robustly. In this exercise, you'll write multiple functions to multiply a matrix times a vector to compare their performance.  You'll implement some simple optimizations to see how much they affect the results.  Then you'll think about the implications of the results for your project.
"""

# ╔═╡ b15b1a8d-b5cb-4cc2-933d-122d385501f8
md"""
## Using Julia's default library 
First, we'll write a function `multiply_matrix_vector_default(A,b)` that takes a matrix A (e.g., type Matrix{Float64} or `Array{Float64,2}`) and a vector b (e.g., type `Vector{Float64` or `Array{Float64,1}`) and returns the product of A times b using Julia's default linear algebra routines.

"""

# ╔═╡ 182715b2-d99d-4a01-aa92-b5dd68804540
"Multiply matrix A and vector b using Julia's built-in linear algebra libraries"
function multiply_matrix_vector_default(A::AbstractMatrix{T1}, b::AbstractVector{T2}) where {T1<:Number, T2<:Number}
    @assert size(A,2)==size(b,1)  # Check that matrix and vector sizes are compatible
    out = A*b                     # Use Julia's default linear algebra routines
end

# ╔═╡ 0024c171-234c-4c4b-9742-064ad8136451
md"""
## Hand-coded, inner loop over rows
1a.  Write a function `multiply_matrix_vector_rows_inner(A,b)`that takes a matrix A and a vector b and returns the product of A times b, but without using Julia's default linear algebra routines. You'll use two loops. For this part, let the inner loop run over the rows (i.e., first index) for A.  You'll likely want to make use of the `size` function.
"""

# ╔═╡ 7390b2d6-c1c2-4498-bcbb-1a8511e29b7d
# INSERT CODE
"Multiply matrix A and vector b by hand using columns for inner loop"
function multiply_matrix_vector_rows_inner(A::Matrix{T1}, b::Vector{T2})  where {T1<:Number, T2<:Number}
	# INSERT CODE
	return missing
end

# ╔═╡ fe202fd4-6d65-4b2e-afa7-67b9ff67f8f0
md"""
### Regression testing (1/2)
Since we have a trusted routine to compute the matrix-vector product, we can build a regression test to make sure that our new function is working correctly.  

1b.  Write a function that takes a `Function` as an argument, compares its output to the results of `multiply_matrix_vector_default` for one to several test cases and returns `true` if it passes and `false` if there's a significant difference.  Remember that you'll need to allow for imperfect matches due to floating point arithmetic.
"""

# ╔═╡ f696696f-1a96-4d65-b2d0-3b7686402b87
function test_mul_mat_vec(func::Function )
	# INSERT CODE
	return missing
end

# ╔═╡ 6f5fc5c6-76d7-4a68-952f-d4e2f2932b07
begin
    if !@isdefined(test_mul_mat_vec)
   		func_not_defined(:test_mul_mat_vec)
    elseif length(methods(test_mul_mat_vec,[Function])) <1
        PlutoTeachingTools.warning_box(md"`test_mul_mat_vec` should take a `Function` as its arguement.")
    elseif ismissing(test_mul_mat_vec(multiply_matrix_vector_default))
        still_missing()
    elseif !test_mul_mat_vec(multiply_matrix_vector_default)
        almost(md"The test should pass when you pass it `multiply_matrix_vector_default`")
    else
        correct(md"I don't recognize a problem.  Before we keep going, let's check that your function passes the test function that you build above.")
    end
end

# ╔═╡ 5c75c2f7-0954-43f9-a674-13abc5cfe156
@test test_mul_mat_vec(multiply_matrix_vector_rows_inner)

# ╔═╡ a266bda6-f64b-43da-b305-382aa233edd3
md"""
### Benchmarking the codes
We'll compare the performance of these two functions on small and large problems.  Before you run the benchmarks, think about how the different versions will perform.
Do you expect there will be a significant difference for small matrices?  large matrices?  
Which version of the function do you predict will perform best for large matrices?  Why?
"""

# ╔═╡ 2c6af190-9cb0-420c-b997-6245adb011a7
response_1c = missing

# ╔═╡ e6cd6185-6933-4857-8007-80ecae3686a7
begin
    if !@isdefined(response_1c)
		var_not_defined(:response_1c)
    elseif ismissing(response_1c)
    	still_missing()
	end
end

# ╔═╡ 5478f83c-e629-4905-a3be-e3027a54d2aa
md"""
I'm ready to run the benchmarks. $(@bind ready_benchmarks1 CheckBox()) 
$(@bind go_benchmarks1 Button("Rerun the benchmarks."))
"""

# ╔═╡ 1bf00606-bdf8-45b1-bf4b-4819029cf2af
tip(md"Remember, we need to make sure your functions have been compiled once before benchmarking for accurate measurements.  We'll use use the [BenchmarkTools.jl package](https://github.com/JuliaCI/BenchmarkTools.jl/)'s macros, `@belapsed`, `@btime` and `@benchmark` to automate that for us.")

# ╔═╡ 33574612-36b9-45ff-bb5b-ecba257ca5c3
md"#### Benchmarks for small problem size"

# ╔═╡ 0b81ae59-a5b2-4151-b0a5-1de070b59520
begin  # Create matrix and vector for first set of benchmarks
	nrows_benchmark1 = 4
	ncols_benchmark1 = 4
	test_in_A1 = rand(nrows_benchmark1,ncols_benchmark1)
	test_in_b1 = rand(ncols_benchmark1)
end;

# ╔═╡ dca91552-f7b5-4e00-8868-0aa70e93b8b9
if ready_benchmarks1 
	md"#### Default Matrix Vector Multiply"
end

# ╔═╡ 45319819-e088-4608-bec4-b71848912fd8
if ready_benchmarks1 
	go_benchmarks1
	@benchmark multiply_matrix_vector_default($test_in_A1,$test_in_b1)
end

# ╔═╡ 454faa95-2134-436d-a39b-02137ba4e9fa
if ready_benchmarks1 
	md"#### Hand-written Inner Loop over Rows"
end

# ╔═╡ af72841c-1f0e-4aa7-a2ed-d01c787b9f31
if ready_benchmarks1 && !ismissing(multiply_matrix_vector_rows_inner(test_in_A1,test_in_b1))
	go_benchmarks1
	@benchmark multiply_matrix_vector_rows_inner($test_in_A1,$test_in_b1)
end

# ╔═╡ a1d17f60-118c-4f3e-8918-50d1411e268b
md"#### Benchmarks for larger problem size"

# ╔═╡ fb42c219-6312-4325-a362-5d8f8d20fd91
begin    # Create matrix and vector for second set of benchmarks
	nrows_benchmark2 = 1024
	ncols_benchmark2 = 1024
	test_in_A2 = rand(nrows_benchmark2,ncols_benchmark2)
	test_in_b2 = rand(ncols_benchmark2)
end;

# ╔═╡ b0d24460-5bda-4ab0-9735-319a1cec55eb
if ready_benchmarks1 
	md"#### Default Matrix Vector Multiply"
end

# ╔═╡ e536cf92-6c80-4b1d-b849-c5a9ab542e9f
if ready_benchmarks1
	@benchmark multiply_matrix_vector_default($test_in_A2,$test_in_b2)
end

# ╔═╡ 28e265b6-148f-418a-a01f-79986d155c90
if ready_benchmarks1 
	md"#### Hand-written Inner Loop over Rows"
end

# ╔═╡ 5929d265-8c2f-488d-9a44-9a95b238c0e8
if ready_benchmarks1 && !ismissing(multiply_matrix_vector_rows_inner(test_in_A1,test_in_b1))
	go_benchmarks1
	@benchmark multiply_matrix_vector_rows_inner($test_in_A2,$test_in_b2)
end

# ╔═╡ 1693883a-8d93-4845-9082-4be0406455f7
md"""1d.  How did the results compare to your expectations?
What do you think explains the differences?"""

# ╔═╡ 61b27b51-2e73-4140-8579-ca62920c4326
response_1d = missing

# ╔═╡ fb912d1a-5465-4b79-b059-8d8ee798479d
begin
    if !@isdefined(response_1d)
		var_not_defined(:response_1d)
    elseif ismissing(response_1d)
    	still_missing()
	end
end

# ╔═╡ 417e47a9-cfa7-4067-afd3-9020c06179de
md"""### Optimize your code"""

# ╔═╡ 773ec174-8bf4-4de6-8dc9-783bfc08694b
md"""
Once your code passes the above tests, and you've compared the first set of benchmarks, compare your code to code in the hint box below.  Consider the advantages and disadvantages of your code and the hint code.  Feel free to update your code above.  """

# ╔═╡ ef3f6c8a-c3a1-4962-b2c6-aa733337c3a1
hint(md"""
```julia
"Multiply matrix A and vector b by hand using rows for inner loop"
function multiply_matrix_vector_rows_inner(A::AbstractMatrix{T1}, b::AbstractVector{T2})  where {T1<:Number, T2<:Number}
    @assert size(A,2) == size(b,1)
    # Allocate output array of correct type and size
    out = zeros( promote_type(eltype(A),eltype(b)), size(A,1) )  
	for j in 1:size(A,2)
        @simd for i in 1:size(A,1)           # Use SIMD over inner loop
            @inbounds out[i] += A[i,j]*b[j]  # Don't check that indicies are valid
        end
    end
    return out
end
```
""")

# ╔═╡ 3b326010-375c-49ba-a670-0b84bea14970
md"1e. Did the benchmarks for your function change significantly?  If so, what made the biggest difference?"

# ╔═╡ d2ff32cd-53c9-45a3-82ae-325b009da8cf
response_1e = missing

# ╔═╡ 128f539d-a4b1-4f03-8c01-821a3a77f92a
begin
    if !@isdefined(response_1e)
		var_not_defined(:response_1e)
    elseif ismissing(response_1e)
    	still_missing()
	end
end

# ╔═╡ 840a059a-cf3b-4a91-a82c-31f28d537854
md"""
## Hand-coded, inner loop over columns
Write a function `multiply_matrix_vector_cols_inner(A,b)` that takes a matrix A and a vector b and returns the product of A times b, but without using Julia's default linear algebra routines. You'll use two loops. For this part, let the inner loop run over the columns (i.e., second index) for A. 
"""

# ╔═╡ e5c7bebd-8ecc-483d-91e1-6e51396078f8
"Multiply matrix A and vector b by hand using columns for inner loop"
function multiply_matrix_vector_cols_inner(A::AbstractMatrix{T1}, b::AbstractVector{T2})  where {T1<:Number, T2<:Number}
    # INSERT CODE
	return missing
end


# ╔═╡ 8723c88f-21eb-4980-876c-cc5d12e48df5
begin
	cols_inner_is_good_to_go = false
    if !@isdefined(multiply_matrix_vector_cols_inner)
   		func_not_defined(:multiply_matrix_vector_cols_inner)
    elseif length(methods(multiply_matrix_vector_cols_inner,[Matrix,Vector])) <1
        PlutoTeachingTools.warning_box(md"`multiply_matrix_vector_cols_inner` should take a `Matrix` and an `Array` as arguemetns")
    elseif ismissing(multiply_matrix_vector_cols_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3]))
        still_missing()
    elseif size(multiply_matrix_vector_cols_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3]))!=(3,)
        almost(md"The size of the `multiply_matrix_vector_cols_inner`'s output isn't right.")
    elseif multiply_matrix_vector_cols_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3])!=[14,32,50]
        almost(md"The values of the output vector aren't right.")
    else
        cols_inner_is_good_to_go = true
        correct()
    end
end

# ╔═╡ ec6f0940-c62c-4387-ba9d-f1deb75ccaef
begin
	rows_inner_is_good_to_go = false
    if !@isdefined(multiply_matrix_vector_rows_inner)
   		func_not_defined(:multiply_matrix_vector_rows_inner)
    elseif length(methods(multiply_matrix_vector_rows_inner,[Matrix,Vector])) <1
        PlutoTeachingTools.warning_box(md"`multiply_matrix_vector_rows_inner` should take a `Matrix` and an `Array` as arguemetns")
    elseif ismissing(multiply_matrix_vector_rows_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3]))
        still_missing()
    elseif size(multiply_matrix_vector_rows_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3]))!=(3,)
        almost(md"The size of the `multiply_matrix_vector_rows_inner`'s output isn't right.")
    elseif multiply_matrix_vector_rows_inner([1 2 3; 4 5 6; 7 8 9],[1,2,3])!=[14,32,50]
        almost(md"The values of the output vector aren't right.")
    else
        rows_inner_is_good_to_go = true
        correct(md"I don't recognize a problem.  Before we keep going, let's check that your function passes the test function that you build above.")
    end
end

# ╔═╡ 15d9141e-5cc1-418d-b7d0-cff276c60fdb
md"""
### Regession testing (2/2) 
Apply your regressions test to your newest function.  
"""

# ╔═╡ 935cc97c-5ece-4280-a32b-e8ff617d5098
@test test_mul_mat_vec(multiply_matrix_vector_cols_inner)

# ╔═╡ a9550934-a11b-4daa-908e-0440ae7aae9d
md"1f. Did the tests work as intended?  Or do you need to make any modifications?"

# ╔═╡ 9011928d-eb84-4a65-a29e-59a3940db964
response_1f = missing

# ╔═╡ 837e07fe-11d4-423f-986c-4a7429a84cee
begin
    if !@isdefined(response_1f)
		var_not_defined(:response_1f)
    elseif ismissing(response_1f)
    	still_missing()
	end
end

# ╔═╡ 0c3d8725-e7a9-4d75-bb5b-1e30bca6fd96
md"""
## Comparing Memory Access Patterns
1g. Once your new function passes your test, predict how it will perform relative to you first function that loops over rows in the inner loop for both small and large matrices.  Then click the button to run benchmarks.
"""

# ╔═╡ 77b2f0b0-5518-47f7-8a98-b30ed4f5cbaf
response_1g = missing

# ╔═╡ 9c0078b5-a9c8-41f9-9244-32dc2d0fdc87
begin
    if !@isdefined(response_1g)
		var_not_defined(:response_1g)
    elseif ismissing(response_1g)
    	still_missing()
	end
end

# ╔═╡ 607e4344-662b-4aa9-95b5-20339cf22a96
md"""
I'm ready to run the benchmarks. $(@bind ready_benchmarks2 CheckBox()) 
$(@bind go_benchmarks2 Button("Rerun the benchmarks."))
"""

# ╔═╡ e44f3c77-c7a6-4d2a-a9f4-a167009c2008
md"#### Benchmarks for inner loop over collumns, small problem size"

# ╔═╡ b2596db9-019e-4cee-8680-113dcaeb09eb
if ready_benchmarks2 && !ismissing(multiply_matrix_vector_cols_inner(test_in_A1,test_in_b1))
	go_benchmarks2
	@benchmark multiply_matrix_vector_cols_inner($test_in_A1,$test_in_b1)
end

# ╔═╡ 4b8f0b1d-17d7-4b69-a485-1443e84ce167
md"#### Benchmarks for inner loop over columns, larger problem size"

# ╔═╡ 57f0d4a5-2b4d-45cb-941c-2f0f369cfc2c
if ready_benchmarks2 && !ismissing(multiply_matrix_vector_cols_inner(test_in_A1,test_in_b1))
	go_benchmarks2
	@benchmark multiply_matrix_vector_cols_inner($test_in_A2,$test_in_b2)
end

# ╔═╡ 52f48403-263b-4a6a-82dc-26671f4e7871
md"How did your function looping over rows in the inner loop perform?  How did the results compare to your predictions?"

# ╔═╡ 99fd596c-efae-4cf1-8e91-f46b5791f3f3
response_1h = missing

# ╔═╡ a65d3972-9870-4a76-bba7-bcaccc10ecfb
begin
    if !@isdefined(response_1h)
		var_not_defined(:response_1h)
    elseif ismissing(response_1h)
    	still_missing()
	end
end

# ╔═╡ 9028e886-dd3a-4c68-a4e9-d3f9ae65cbdf
md"""
### Benchmark as a function of problem size
Now, let's plotthe performance of all three functions as a function of problem size.  
"""

# ╔═╡ 4781aac2-5f70-4e95-afc0-353c1419c97c
begin
	nrows_benchmark_plt = floor.(Int64,sqrt(2).^(3:22))
	ncols_square_benchmark_plt = nrows_benchmark_plt
end

# ╔═╡ d615c199-4b33-4844-a87f-c9512f2481a3
function run_benchmarks(nrows, ncols)
	@assert length(nrows) == length(ncols)
	times_default = zeros(length(nrows))
	times_rows = zeros(length(nrows))
	times_cols = zeros(length(nrows))

	for i in 1:length(nrows_benchmark_plt)
		test_in_A_plt = rand(nrows[i],ncols[i])
		test_in_b_plt = rand(ncols[i])
		times_default[i] = @elapsed multiply_matrix_vector_default(test_in_A_plt,test_in_b_plt)
		times_rows[i] = @elapsed multiply_matrix_vector_rows_inner(test_in_A_plt,test_in_b_plt)
		times_cols[i] = @elapsed multiply_matrix_vector_cols_inner(test_in_A_plt,test_in_b_plt)
	end
	return (times_default, times_rows, times_cols)
end

# ╔═╡ 2eef234f-b93b-4fe4-ac50-445da9ffb8e7
(times_square_default_plt, times_square_rows_plt, times_square_cols_plt ) = run_benchmarks(nrows_benchmark_plt, ncols_square_benchmark_plt);

# ╔═╡ 96476ef8-3275-492c-9caf-4c2702d84167
function plot_benchmarks(nrows, times_default, times_rows, times_cols)
	plt = plot(xlabel="Num Rows", ylabel="Time (s)",legend=:topleft, xscale=:log10, yscale=:log10)
	plot!(plt,nrows,times_default, label = :none, lc=1)
	scatter!(plt,nrows,times_default, label = "Default", mc=1)
	plot!(plt,nrows,times_rows, label = :none, lc=2)
	scatter!(plt,nrows,times_rows, label = "Rows Inner", mc=2)
	plot!(plt,nrows,times_cols, label = :none, lc=3)
	scatter!(plt,nrows,times_cols, label = "Collumns Inner", mc=3)
	return plt	
end

# ╔═╡ 412777aa-ec37-4062-a3e6-4e844add94c0
begin 
	local plt = plot_benchmarks(nrows_benchmark_plt,times_square_default_plt, times_square_rows_plt,times_square_cols_plt)
	title!(plt,"Square")
end

# ╔═╡ 988b3ec3-71cd-4ea4-b007-e7d2c16d3502
md"The above plot is for square problems.  You can look at additional benchmarks before for short or tall vectors below."

# ╔═╡ b2132261-aa1f-4db0-a6ef-95f763f390d9
ncols_short_benchmark_plt = max.(1,floor.(Int64,nrows_benchmark_plt ./ 4 ))

# ╔═╡ d871280d-4e70-41a3-bee2-f81c1844ef2b
ncols_tall_benchmark_plt = 4 .* nrows_benchmark_plt

# ╔═╡ b57bfd3b-1d81-4256-8634-41173b2ed93a
(times_short_default_plt, times_short_rows_plt, times_short_cols_plt ) = run_benchmarks(nrows_benchmark_plt, ncols_short_benchmark_plt)

# ╔═╡ b6879ac5-9521-4b9b-b488-3c98ed87960a
(times_tall_default_plt, times_tall_rows_plt, times_tall_cols_plt ) = run_benchmarks(nrows_benchmark_plt, ncols_tall_benchmark_plt)

# ╔═╡ 07ea6486-edba-4174-b0ee-0cf98096b785
begin
	plt_tall = plot_benchmarks(nrows_benchmark_plt,times_tall_default_plt, times_tall_rows_plt,times_tall_cols_plt)
	title!(plt_tall,"Tall")
	plt_short = plot_benchmarks(nrows_benchmark_plt,times_short_default_plt, times_short_rows_plt,times_short_cols_plt)
	title!(plt_short,"Short")
	plot(plt_tall,plt_short,layout=(1,2))
end

# ╔═╡ 19b9c838-ad9e-45f2-bc46-ea239415b175
md"""
### Implications for your project

1i.  Are there any implications of this lesson for the data structures or choice of memory access patterns that you will use for your project?
"""

# ╔═╡ d59f6e79-4376-42ec-abdc-baa0b4541009
response_1i = missing

# ╔═╡ d946cca6-a261-436d-bc56-6d1345c081d3
begin
    if !@isdefined(response_1i)
		var_not_defined(:response_1i)
    elseif ismissing(response_1i)
    	still_missing()
	end
end

# ╔═╡ ec61c53b-c777-4fbc-b73e-6878e5e6e8c4
md"# Helper Code"

# ╔═╡ 1168a71d-ddad-4d4f-bc37-8b609e3ab47e
ChooseDisplayMode()

# ╔═╡ 6a9e8fe0-259b-4826-9eaa-667cdbb8dfca
TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
BenchmarkTools = "~1.1.3"
Plots = "~1.20.1"
PlutoTeachingTools = "~0.1.3"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "aa3aba5ed8f882ed01b71e09ca2ba0f77f44a99e"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.3"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d59e8320c2747553788e4fc42231489cc602fa50"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.1+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "501c20a63a34ac1d015d5304da0e645f42d91c9f"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.11"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "8365fa7758e2e8e4443ce866d6106d8ecbb4474e"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.20.1"

[[PlutoTeachingTools]]
deps = ["LaTeXStrings", "Markdown", "PlutoUI", "Random"]
git-tree-sha1 = "e2b63ee022e0b20f43fcd15cda3a9047f449e3b4"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.1.4"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "3479836b31a31c29a7bac1f09d95f9c843ce1ade"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "2a7a2469ed5d94a98dea0e85c46fa653d76be0cd"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.4"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "fed1ec1e65749c4d96fc20dd13bea72b55457e62"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.9"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "000e168f5cc9aded17b6999a560b7c11dda69095"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.0"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─6856a387-a359-45ae-a70a-7eb6665097bd
# ╟─b15b1a8d-b5cb-4cc2-933d-122d385501f8
# ╠═182715b2-d99d-4a01-aa92-b5dd68804540
# ╟─0024c171-234c-4c4b-9742-064ad8136451
# ╠═7390b2d6-c1c2-4498-bcbb-1a8511e29b7d
# ╟─8723c88f-21eb-4980-876c-cc5d12e48df5
# ╟─fe202fd4-6d65-4b2e-afa7-67b9ff67f8f0
# ╠═f696696f-1a96-4d65-b2d0-3b7686402b87
# ╟─6f5fc5c6-76d7-4a68-952f-d4e2f2932b07
# ╠═5c75c2f7-0954-43f9-a674-13abc5cfe156
# ╟─a266bda6-f64b-43da-b305-382aa233edd3
# ╠═2c6af190-9cb0-420c-b997-6245adb011a7
# ╟─e6cd6185-6933-4857-8007-80ecae3686a7
# ╟─5478f83c-e629-4905-a3be-e3027a54d2aa
# ╟─1bf00606-bdf8-45b1-bf4b-4819029cf2af
# ╟─33574612-36b9-45ff-bb5b-ecba257ca5c3
# ╠═0b81ae59-a5b2-4151-b0a5-1de070b59520
# ╟─dca91552-f7b5-4e00-8868-0aa70e93b8b9
# ╟─45319819-e088-4608-bec4-b71848912fd8
# ╟─454faa95-2134-436d-a39b-02137ba4e9fa
# ╟─af72841c-1f0e-4aa7-a2ed-d01c787b9f31
# ╟─a1d17f60-118c-4f3e-8918-50d1411e268b
# ╟─fb42c219-6312-4325-a362-5d8f8d20fd91
# ╟─b0d24460-5bda-4ab0-9735-319a1cec55eb
# ╟─e536cf92-6c80-4b1d-b849-c5a9ab542e9f
# ╟─28e265b6-148f-418a-a01f-79986d155c90
# ╟─5929d265-8c2f-488d-9a44-9a95b238c0e8
# ╟─1693883a-8d93-4845-9082-4be0406455f7
# ╠═61b27b51-2e73-4140-8579-ca62920c4326
# ╟─fb912d1a-5465-4b79-b059-8d8ee798479d
# ╟─417e47a9-cfa7-4067-afd3-9020c06179de
# ╟─773ec174-8bf4-4de6-8dc9-783bfc08694b
# ╟─ef3f6c8a-c3a1-4962-b2c6-aa733337c3a1
# ╟─3b326010-375c-49ba-a670-0b84bea14970
# ╠═d2ff32cd-53c9-45a3-82ae-325b009da8cf
# ╟─128f539d-a4b1-4f03-8c01-821a3a77f92a
# ╟─840a059a-cf3b-4a91-a82c-31f28d537854
# ╠═e5c7bebd-8ecc-483d-91e1-6e51396078f8
# ╟─ec6f0940-c62c-4387-ba9d-f1deb75ccaef
# ╟─15d9141e-5cc1-418d-b7d0-cff276c60fdb
# ╠═935cc97c-5ece-4280-a32b-e8ff617d5098
# ╟─a9550934-a11b-4daa-908e-0440ae7aae9d
# ╠═9011928d-eb84-4a65-a29e-59a3940db964
# ╟─837e07fe-11d4-423f-986c-4a7429a84cee
# ╟─0c3d8725-e7a9-4d75-bb5b-1e30bca6fd96
# ╠═77b2f0b0-5518-47f7-8a98-b30ed4f5cbaf
# ╟─9c0078b5-a9c8-41f9-9244-32dc2d0fdc87
# ╟─607e4344-662b-4aa9-95b5-20339cf22a96
# ╟─e44f3c77-c7a6-4d2a-a9f4-a167009c2008
# ╠═b2596db9-019e-4cee-8680-113dcaeb09eb
# ╟─4b8f0b1d-17d7-4b69-a485-1443e84ce167
# ╠═57f0d4a5-2b4d-45cb-941c-2f0f369cfc2c
# ╟─52f48403-263b-4a6a-82dc-26671f4e7871
# ╠═99fd596c-efae-4cf1-8e91-f46b5791f3f3
# ╟─a65d3972-9870-4a76-bba7-bcaccc10ecfb
# ╟─9028e886-dd3a-4c68-a4e9-d3f9ae65cbdf
# ╠═4781aac2-5f70-4e95-afc0-353c1419c97c
# ╟─d615c199-4b33-4844-a87f-c9512f2481a3
# ╟─2eef234f-b93b-4fe4-ac50-445da9ffb8e7
# ╟─96476ef8-3275-492c-9caf-4c2702d84167
# ╟─412777aa-ec37-4062-a3e6-4e844add94c0
# ╟─988b3ec3-71cd-4ea4-b007-e7d2c16d3502
# ╠═b2132261-aa1f-4db0-a6ef-95f763f390d9
# ╠═d871280d-4e70-41a3-bee2-f81c1844ef2b
# ╠═b57bfd3b-1d81-4256-8634-41173b2ed93a
# ╠═b6879ac5-9521-4b9b-b488-3c98ed87960a
# ╟─07ea6486-edba-4174-b0ee-0cf98096b785
# ╟─19b9c838-ad9e-45f2-bc46-ea239415b175
# ╠═d59f6e79-4376-42ec-abdc-baa0b4541009
# ╟─d946cca6-a261-436d-bc56-6d1345c081d3
# ╟─ec61c53b-c777-4fbc-b73e-6878e5e6e8c4
# ╟─1168a71d-ddad-4d4f-bc37-8b609e3ab47e
# ╠═06e16a4a-fdc3-11eb-0462-d3dce4d54728
# ╠═6a9e8fe0-259b-4826-9eaa-667cdbb8dfca
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
