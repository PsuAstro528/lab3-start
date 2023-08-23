### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
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
"Multiply matrix A and vector b by hand using columns for inner loop"
function multiply_matrix_vector_rows_inner(A::Matrix{T1}, b::Vector{T2})  where {T1<:Number, T2<:Number}
	# INSERT CODE
	return missing
end

# ╔═╡ 8723c88f-21eb-4980-876c-cc5d12e48df5
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


# ╔═╡ ec6f0940-c62c-4387-ba9d-f1deb75ccaef
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
md"How did your function looping over columns in the inner loop perform?  How did the results compare to your predictions?"

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
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "c0616f55adccd36904143679582293766beebbdd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1596bab77f4f073a14c62424283e7ebff3072eca"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e8ab063deed72e14666f9d8af17bd5f9eab04392"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.24"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "a03c77519ab45eb9a34d3cfe2ca223d79c064323"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.1"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "bbb5c2115d63c2f1451cb70e5ef75e8fe4707019"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.22+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "607c142139151faa591b5e80d8055a15e487095b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.16.3"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
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
