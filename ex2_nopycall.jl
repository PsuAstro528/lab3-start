### A Pluto.jl notebook ###
# v0.19.27

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

# ╔═╡ ac87ced2-986f-4e6c-80b2-104b25c171c2
begin
	using CSV, JLD2, FITSIO, FileIO# , HDF5
	using DataFrames #, Query
	using PyCall
	using PlutoUI, PlutoTeachingTools
	eval(Meta.parse(code_for_check_type_funcs))
end

# ╔═╡ e0e60e09-3808-4d6b-a773-6ba59c02f517
md"""
# Astro 528, Lab 3, Exercise 2
# Benchmarking File I/O
# (no Python dependance)
"""

# ╔═╡ 8c1d81ab-d215-4972-afeb-7e00bf6063c2
md"""
For many applications, its important that we be able to read input data from a file and/or to write our outputes to files so they can be reused later.  Disk access is typically much slower than accessing system memory.  Therefore, disk access can easily become the limiting factor for a project.  In this set of exercises, you'll see examples of how to perform basic file I/O. 

You'll be provided with most of the code you need, so that you can focus on comparing how much disk space and time is required by different file formats.  Near the end of the lab, you'll be asked to think about when each type of file format would be a good choice for you to use in your research projects.
"""

# ╔═╡ 1607eac9-e76f-4d1f-a9ce-981ce3be9bea
md"""
### Download some data
First, we're going to download some data from the web.  Julia has a built in `download` function that can be handy for this.  It relies on your system having some utilities already installed (e.g., `curl`, `wget` or `fetch`).  If you run this on a local system and run into trouble, then you can leave the cell below, and manually download the file to the data subdirectory.
"""

# ╔═╡ f27e1e8f-15eb-4754-a94c-7f37c54b871e
begin 
	path = basename(pwd())=="test" ? "../data/" : "data/"
	if !isdir(path)  mkdir(path)  end  # make sure there's a data directory
	url = "https://raw.githubusercontent.com/PsuAstro528/lab3-start/data/data/kplr_dr25_inj1_plti.csv"
	filename_csv = joinpath(path,basename(url)) # extract the filename and prepend "data/"
	time_to_download = NaN
	if !isfile(filename_csv)  # skip downloading if file already exists
	    time_to_download = @elapsed download(url,filename_csv)
	end
end

# ╔═╡ 80f02c3a-6751-48df-92ec-13f5c7d8c71e
if !isnan(time_to_download)
	md"Downloading the file took $time_to_download seconds."
end

# ╔═╡ 624c9038-3008-4e78-a149-60796dacf9c0
md"""
Previously, everything you needed for an assignment was included in a GitHub repository.  So why did I make you download the file?

Notice the size of the file.  Git is great for tracking source code, but it wasn't really designed for working with large files (especially large _binary_ files).  Since  we're not going to be editing it, we'll simply download it once.  
"""

# ╔═╡ c808d0e1-4829-432f-b91f-968d4be20ecf
md"""
(We're skipping 2a-2d, since we're avoiding using Python in this notebook.)
"""

# ╔═╡ 191ba96e-2573-4bc1-a352-46a66e0a5c4f
md"""
## CSV files
Let's say that we'd like to read/write data as [CSV files](https://en.wikipedia.org/wiki/Comma-separated_values), so that it's easy for other programs to read in.  Using the CSV package, we can read a CSV file into a DataFrame (or several other tabular data structures) and write CSV files from a DataFrame with code like the following.
"""

# ╔═╡ 82a757ad-566d-4c1d-8b3d-366ffd980fb4
begin
	# Read & write a small test file so compilation time not included below
	n_small_df = 1024
	small_csv_filename = "random_numbers.csv"
	small_df = DataFrame(a=rand(n_small_df),b=rand(n_small_df) ) 
	CSV.write(joinpath(path,small_csv_filename),small_df)  
	small_df_from_csv = CSV.read(joinpath(path,small_csv_filename),DataFrame) 
end;

# ╔═╡ 32124f8a-f5cf-41d1-97a9-ce1d05145fde
md"""
2d. How long do you think it will take to read 146,294 rows and 25 columns of data data stored in CSV format?
"""

# ╔═╡ 507e1516-5433-49eb-831d-32426f30895e
response_2d = missing

# ╔═╡ eac67cc9-754b-4f7d-add8-93900a1b5b49
display_msg_if_fail(check_type_isa(:response_2d,response_2d,[AbstractString,Markdown.MD]))

# ╔═╡ 73c06bb1-be49-46bd-b7f1-c45cc56af7b4
md"""
I'm ready to benchmark reading a CSV file. $(@bind ready_read_csv CheckBox()) 
$(@bind go_read_csv Button("Rerun the benchmarks."))
"""

# ╔═╡ ebfaa677-829b-4bf9-bdbb-19f3c87dd3a4
if  ready_read_csv
	go_read_csv
	time_read_csv = @elapsed df_csv = CSV.read(filename_csv, DataFrame)
	already_benchmarked_csv_read = true
	md"It took $time_read_csv seconds to read the CSV file."
end

# ╔═╡ b0c3875b-ef07-4e92-a0a8-55f42b266c6b
if ready_read_csv && already_benchmarked_csv_read
	ready_read_csv
	df = CSV.read(filename_csv,DataFrame,types=Dict(:TCE_ID=>String),missingstring="NA")
end

# ╔═╡ 945f5a55-3026-4497-9ece-8af878c87788
md"""
2e.  How did the time required to read the data in CSV format compare to your expectation?  If you were suprsised, try to explain what happened.
"""

# ╔═╡ 57397ee4-9efc-48b3-b640-d2b7a10da633
response_2e = missing

# ╔═╡ 8059a6a3-384a-4344-8a23-650ee0be10c2
display_msg_if_fail(check_type_isa(:response_2e,response_2e,[AbstractString,Markdown.MD]))

# ╔═╡ 64224c6b-c5a0-44f2-b2a0-7f77759cb848
md"""
Now, we'll try writing the same data out to a new CSV file.  
"""

# ╔═╡ f5b93929-2c59-4360-8c41-97a1324ba455
md"2f. How long do you think it will take to write the same data?  Once you've made your prediction, mouse over the hint box.  If you were suprsised, try to explain what happened."

# ╔═╡ 122196fa-45ca-4031-85eb-4afd4782de9e
response_2f = missing

# ╔═╡ e9dc1456-616b-4e4b-b209-9f6ba4c48607
display_msg_if_fail(check_type_isa(:response_2f,response_2f,[AbstractString,Markdown.MD]))

# ╔═╡ 3e550b71-4750-460b-be18-911a848a8f49
if  ready_read_csv
	go_read_csv
	filename_csv_out = replace(filename_csv, ".csv" => "_2.csv")  
	time_write_csv = @elapsed CSV.write(filename_csv_out, df)
end;

# ╔═╡ f15d37a7-d962-4da0-977f-76729a3313be
hint(md"It took $time_write_csv seconds to write the CSV file.")

# ╔═╡ 28f195c4-4f61-4873-85d6-b4e3aaa3660f
md"""
## Binary formats: HDF5/JLD2

There are numerous binary file formats that one could use.  Here, we'll try using JLD2 which is a subset of the [HDF5](https://www.hdfgroup.org/solutions/hdf5/) file format.  This means that when [Julia's JLD2 package](https://github.com/JuliaIO/JLD2.jl) writes jld2 files, they can be read by other programs that can read HDF5 files.  However, a generic HDF5 file is not a valid JLD2 file.  If you want to read a HDF5 file, then you can use Julia's [HDF5.jl package](https://github.com/JuliaIO/HDF5.jl).  The [FileIO.jl](https://github.com/JuliaIO/FileIO.jl) package provides a common interface for reading and writing from multiple file formats, including these and several others.

As before, we'll call each function once using a small DataFrame, just so they get compiled before we benchmark them.
"""

# ╔═╡ 3837e439-250b-4577-b0d7-93352ec19f6e
begin
	filename_jld2_small = replace(small_csv_filename, ".csv" => ".jld2")  
	@save joinpath(path,filename_jld2_small) small_df 
	small_df_from_jld2 = load(joinpath(path,filename_jld2_small), "small_df")
end;

# ╔═╡ df9b701f-d314-4512-b2ea-1f6ae015166c
response_2g = missing

# ╔═╡ 377f7527-a338-4526-bb24-9766c635e719
display_msg_if_fail(check_type_isa(:response_2g,response_2g,[AbstractString,Markdown.MD]))

# ╔═╡ 25f24754-16d4-4343-b54a-cf8ea1358ce9
begin 
	small_jld2_filesize = filesize(joinpath(path,filename_jld2_small))/1024
	small_csv_filesize = filesize(joinpath(path,small_csv_filename))/1024
	hint(md"For the small random data set, the JLD2 file's size is $small_jld2_filesize KB versus $small_csv_filesize KB for the CSV file.")
end

# ╔═╡ 8255b5a9-cbe6-4604-bedd-0e366f311096
md"""
Let's check the filesizes for the JLD2 file to the CSV file.  
The small CSV file we created is $small_csv_filesize KB.  

2g.  How large would you guess the JLD2 file will be?  Once you've made your prediction, mouse over the hint box.  If you were suprised, try to explain what happened.
"""

# ╔═╡ 570fd826-23fd-46ee-bdb4-58fb0c45719a
md"""
Now let's time how long it takes to save the data from CSV into a JLD2 file.
"""

# ╔═╡ 691410bb-0472-4800-a90d-29ddf947de3e
begin
	filename_jld2 = replace(filename_csv, ".csv" => ".jld2") 
	with_terminal() do 
		@time @save filename_jld2 df
	end
end

# ╔═╡ 8cbb1c90-bd94-44b5-80b6-81d38f3e6252
md"2h.  How long do you think it will take to load the data from the JLD2 file? "

# ╔═╡ c3065acf-6205-455f-ba74-ca51f3f6761b
response_2h = missing

# ╔═╡ 9c392be9-1505-40bc-a290-68085a1c2700
display_msg_if_fail(check_type_isa(:response_2h,response_2h,[AbstractString,Markdown.MD]))

# ╔═╡ d738bdcc-5f83-4dfa-a17f-e9ea23db2986
md"""
Now time how long it takes to load the data from the JLD2 file.
"""

# ╔═╡ d55ce157-099c-4c1b-94db-62918f04e5fe
md"""
I'm ready to benchmark reading a JLD2 file. $(@bind ready_read_jld2 CheckBox()) 
$(@bind go_read_jld2 Button("Rerun the benchmarks."))
"""

# ╔═╡ 206f464b-55fe-46aa-85b7-8f0246a0aaad
if ready_read_jld2
	go_read_jld2
	time_read_jld2 = @elapsed df_jld2_read_back_in = load(filename_jld2, "df")
	md"It took $time_read_jld2 seconds to read the JLD2 file."
end

# ╔═╡ 6f72d1b2-63f6-4301-8272-bb2d6d2d049e
md"""
2i.  How does the time required to read and write the JLD2 file compare to the time required to read the CSV formatted files?  If you were suprised, try to explain what happend.
"""

# ╔═╡ 01201c37-0b79-46b1-a001-e716f5b3ba67
response_2i = missing

# ╔═╡ e3d37bc1-a119-4add-a111-899ee0caea05
display_msg_if_fail(check_type_isa(:response_2i,response_2i,[AbstractString,Markdown.MD]))

# ╔═╡ 39eff7cf-6f6c-4aac-91a7-b776e0a62c45
csv_filesize = filesize(filename_csv) / 1024^2;

# ╔═╡ 6dff3f21-fac0-42e1-910a-f969a231374f
md"""
Next, we'll compare the filesizes for the JLD2 file to the CSV file. The CSV file is $csv_filesize MB. 

2j.  How large would you guess the JLD2 file will be?  Once you've made your prediction, mouse over the hint box.  If you were suprised, try to explain what happened.
"""

# ╔═╡ b26b8253-e6cd-49f4-81c5-2a3c2963a37c
response_2j = missing

# ╔═╡ e5dc123f-1596-4311-9398-f0cfe80a5342
display_msg_if_fail(check_type_isa(:response_2j,response_2j,[AbstractString,Markdown.MD]))

# ╔═╡ 7b9d26c2-899e-45e9-b664-39d5f1adfe3f
begin 
	jld2_filesize = filesize(filename_jld2) / 1024^2;
	hint(md"The JLD2 file size is $jld2_filesize MB.")
end

# ╔═╡ fc01d57f-c90b-4231-96be-ddd48656d55e
md"""
## Flexible Format: FITS

Astronomers often use the [FITS file format](https://en.wikipedia.org/wiki/FITS).  Like [HDF
5](https://www.hdfgroup.org/solutions/hdf5/), it's a very flexible (e.g., it can store both text and binary data) and thus complicated file
 format.  
Therefore, most languages call a common [FITSIO library written in C](https://heasarc.gsfc.nasa.gov/fitsio/), rather than implementing code themselves.  Indeed, that's what [Julia's FITSIO.jl package](https://github.com/JuliaAstro/FITSIO.jl) does.

Unfortunately, the FITSIO package isn't as polished as the others.  It expects a `Dict` rather than a `DataFrame`, and it can't handle missing values.  So I've provided some helper functions at the bottom of the notebook.  Also, FITS files have complicated headers, so I'll provide a function to read all the tabular data from a simple FITS file.  As usual, we'll use each function once, so that Julia compiles them before we start timing.
"""

# ╔═╡ e05f16d6-eb50-49a9-bf14-95d63c9da7ff
begin
	filename_fits_small = replace(small_csv_filename, ".csv" => ".fits")  
	write_dataframe_as_fits(joinpath(path,filename_fits_small),small_df)
	read_fits_tables(joinpath(path,filename_fits_small))
end;

# ╔═╡ 3b232365-f2fe-4edb-a39f-3e37c8cbb666
md"Now we can time how long it takes to write and read the data as FITS files."

# ╔═╡ 1992595f-9976-4b18-bf9c-df8a73d30dc8
begin
	filename_fits_small # make sure have already compiled functions
	filename_fits = replace(filename_csv, ".csv" => ".fits") 
	with_terminal() do 
		@time write_dataframe_as_fits(filename_fits,df)
	end
end

# ╔═╡ 568862b3-6fce-426a-a9e2-e558adf3932a
md"""
I'm ready to benchmark reading a FITS file. $(@bind ready_read_fits CheckBox()) 
$(@bind go_read_fits Button("Rerun the benchmarks."))
"""

# ╔═╡ 52f9edd0-79b0-4a9a-9930-3a05d3aa2447
if ready_read_fits
	go_read_fits
	time_read_fits = @elapsed read_fits_tables(filename_fits)
	md"It took $time_read_fits seconds to read the FITS file."
end

# ╔═╡ 90d5244e-17be-4601-b922-8c254f1248bf
begin
	fits_filesize = filesize(filename_fits) /1024^2
	hint(md"The FITS file size is $fits_filesize MB versus $jld2_filesize MB for the JLD2 and $csv_filesize MB for the CSV.")
end

# ╔═╡ ae79ee89-d788-4612-8b1d-fc22d85c7744
md"2k.  How do the read/write times and file sizes for FITS compare to CSV and JLD2?"

# ╔═╡ 3745c237-ba48-4f2c-959e-441484244764
response_2k = missing

# ╔═╡ 6d061411-6f19-4119-aefb-cc380198b0ce
display_msg_if_fail(check_type_isa(:response_2k,response_2k,[AbstractString,Markdown.MD]))

# ╔═╡ 8def87d2-f10b-4a82-b353-a6477eeead9b
md"## Implications for your project"

# ╔═╡ c74b3105-f480-4688-b85f-3e7dff70da3b
md"""
2l.  How does the time required to read any of the above formats compare to the time required to download the files ($time_to_download seconds)?  
Will your project need to transfer large files over the internet?  If so, very roughly how large do you expect they will be?  
"""

# ╔═╡ 55438c09-1d94-4ff7-90c3-0cc6064a091e
response_2l = missing

# ╔═╡ bcc796c9-db11-4a09-a5f9-215127ac0938
display_msg_if_fail(check_type_isa(:response_2l,response_2l,[AbstractString,Markdown.MD]))

# ╔═╡ 92b2ecdd-9491-4f16-8cb9-bacbcf180280
md"""
2m.  Will your project need to read in any input files?  If so, what format are they in?  

I assume everyone's project code will write at least some output files?  Very roughly, how large do you expect that they'll be?   What format(s) would be a good choice for your project?"""

# ╔═╡ 83216915-cdcf-4f0f-829f-a5ff4c4b8da0
response_2m = missing

# ╔═╡ 452872f9-2009-4733-b2d3-28f262ae19b7
display_msg_if_fail(check_type_isa(:response_2m,response_2m,[AbstractString,Markdown.MD]))

# ╔═╡ 29415ddc-e002-4f56-a169-95f7b1c36be9
md"# Helper Functions"

# ╔═╡ fb23d6c6-b812-4fe1-b224-0014bedbd43f
ChooseDisplayMode()

# ╔═╡ 1e53aa10-dff6-40d5-89e2-da194ffc2052
TableOfContents()

# ╔═╡ 14cca8ce-cc61-4fae-b871-21c3fd23d0ea
"Convert a DataFrame to a Dict"
function convert_dataframe_to_dict_remove_missing(df::DataFrame)
#=
	"Convert a DataFrame to a Dict, replacing missing values with 0 or an empty string."
	d = Dict(map(n->"$n"=>               # create a dictionary
              ( any(ismissing.(df[!,n])) ? # if column contains a missing
                    map(x-> !ismissing(x) ? # search for missings
                        x :                 # leave non-missing values alone
                        ( (eltype(df[!,n]) <: Number) ? zero(eltype(n)) : "")
                        , df[!,n])            # but replace missing with 0 or ""
                : df[!,n] ), # if nothing is missing, just use column as is
            names(df) ))  
=#
	d = Dict(zip(names(df),collect.(eachcol(df))))
end

# ╔═╡ 28fc8de4-749b-4093-b32f-c398f8d27d3d
"Write a DataFrame to a FITS file, replacing missing values with 0 or an empty string."
function write_dataframe_as_fits(filename::String, df::DataFrame)
    try 
       dict = convert_dataframe_to_dict_remove_missing(df) 
       fits_file = FITS(filename,"w")
       write(fits_file, dict )
       close(fits_file)
    catch
        @warn("There was a problem writing a dataframe to " * filename * ".")
    end
end


# ╔═╡ 57b422e5-0ad0-4674-bdd3-a8358bc7aaeb

"Read the columns of the first table from a FITS file into a Dict"
function read_fits_tables(filename::String)
    dict = Dict{String,Any}()
    fits_file = FITS(filename,"r")
    # fits_file[1] is image data, we're interested in the table
    @assert length(fits_file) >= 2
    header = read_header(fits_file[2])
    for i in 1:length(header)
        c = get_comment(header,i)
        if !occursin("label for field",c)
            continue
        end
        h = header[i]
        @assert typeof(h) == String
        try  
            dict[h] = read(fits_file[2],h)
        catch
            @warn "# Problem reading table column " * h * "."
        end
    end
    close(fits_file)
    return dict
end


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FITSIO = "525bcba6-941b-5504-bd06-fd0dc1a4d2eb"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
JLD2 = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
CSV = "~0.10.11"
DataFrames = "~1.6.1"
FITSIO = "~0.17.1"
FileIO = "~1.16.1"
JLD2 = "~0.4.33"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
PyCall = "~1.96.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "4d7b3c33160a2ec5ba79009b0e5679210ba2d795"

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

[[deps.CFITSIO]]
deps = ["CFITSIO_jll"]
git-tree-sha1 = "8425c47db102577eefb93cb37b4480e750116b0d"
uuid = "3b1b4be9-1499-4b22-8d78-7db3344d1961"
version = "1.4.1"

[[deps.CFITSIO_jll]]
deps = ["Artifacts", "JLLWrappers", "LibCURL_jll", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "9c91a9358de42043c3101e3a29e60883345b0b39"
uuid = "b3e40c51-02ae-5482-8a39-3ace5868dcf4"
version = "4.0.0+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "8c86e48c0db1564a1d49548d3515ced5d604c408"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.9.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FITSIO]]
deps = ["CFITSIO", "Printf", "Reexport", "Tables"]
git-tree-sha1 = "a8924c203d66d4c5d72980572c6810213422a59d"
uuid = "525bcba6-941b-5504-bd06-fd0dc1a4d2eb"
version = "0.17.1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "aa6ffef1fd85657f4999030c52eaeec22a279738"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.33"

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

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

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

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

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

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "ee094908d720185ddbdc58dbe0c1cbe35453ec7a"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "43d304ac6f0354755f1d60730ece8c499980f7ba"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

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

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─e0e60e09-3808-4d6b-a773-6ba59c02f517
# ╟─8c1d81ab-d215-4972-afeb-7e00bf6063c2
# ╟─1607eac9-e76f-4d1f-a9ce-981ce3be9bea
# ╠═f27e1e8f-15eb-4754-a94c-7f37c54b871e
# ╟─80f02c3a-6751-48df-92ec-13f5c7d8c71e
# ╟─624c9038-3008-4e78-a149-60796dacf9c0
# ╟─c808d0e1-4829-432f-b91f-968d4be20ecf
# ╟─191ba96e-2573-4bc1-a352-46a66e0a5c4f
# ╠═82a757ad-566d-4c1d-8b3d-366ffd980fb4
# ╟─32124f8a-f5cf-41d1-97a9-ce1d05145fde
# ╠═507e1516-5433-49eb-831d-32426f30895e
# ╟─eac67cc9-754b-4f7d-add8-93900a1b5b49
# ╟─73c06bb1-be49-46bd-b7f1-c45cc56af7b4
# ╟─ebfaa677-829b-4bf9-bdbb-19f3c87dd3a4
# ╠═b0c3875b-ef07-4e92-a0a8-55f42b266c6b
# ╟─945f5a55-3026-4497-9ece-8af878c87788
# ╠═57397ee4-9efc-48b3-b640-d2b7a10da633
# ╟─8059a6a3-384a-4344-8a23-650ee0be10c2
# ╟─64224c6b-c5a0-44f2-b2a0-7f77759cb848
# ╟─f5b93929-2c59-4360-8c41-97a1324ba455
# ╠═122196fa-45ca-4031-85eb-4afd4782de9e
# ╟─e9dc1456-616b-4e4b-b209-9f6ba4c48607
# ╟─3e550b71-4750-460b-be18-911a848a8f49
# ╟─f15d37a7-d962-4da0-977f-76729a3313be
# ╟─28f195c4-4f61-4873-85d6-b4e3aaa3660f
# ╠═3837e439-250b-4577-b0d7-93352ec19f6e
# ╟─8255b5a9-cbe6-4604-bedd-0e366f311096
# ╠═df9b701f-d314-4512-b2ea-1f6ae015166c
# ╟─377f7527-a338-4526-bb24-9766c635e719
# ╠═25f24754-16d4-4343-b54a-cf8ea1358ce9
# ╟─570fd826-23fd-46ee-bdb4-58fb0c45719a
# ╠═691410bb-0472-4800-a90d-29ddf947de3e
# ╟─8cbb1c90-bd94-44b5-80b6-81d38f3e6252
# ╠═c3065acf-6205-455f-ba74-ca51f3f6761b
# ╟─9c392be9-1505-40bc-a290-68085a1c2700
# ╟─d738bdcc-5f83-4dfa-a17f-e9ea23db2986
# ╟─d55ce157-099c-4c1b-94db-62918f04e5fe
# ╟─206f464b-55fe-46aa-85b7-8f0246a0aaad
# ╟─6f72d1b2-63f6-4301-8272-bb2d6d2d049e
# ╠═01201c37-0b79-46b1-a001-e716f5b3ba67
# ╟─e3d37bc1-a119-4add-a111-899ee0caea05
# ╟─39eff7cf-6f6c-4aac-91a7-b776e0a62c45
# ╟─6dff3f21-fac0-42e1-910a-f969a231374f
# ╠═b26b8253-e6cd-49f4-81c5-2a3c2963a37c
# ╟─e5dc123f-1596-4311-9398-f0cfe80a5342
# ╟─7b9d26c2-899e-45e9-b664-39d5f1adfe3f
# ╟─fc01d57f-c90b-4231-96be-ddd48656d55e
# ╠═e05f16d6-eb50-49a9-bf14-95d63c9da7ff
# ╟─3b232365-f2fe-4edb-a39f-3e37c8cbb666
# ╠═1992595f-9976-4b18-bf9c-df8a73d30dc8
# ╟─568862b3-6fce-426a-a9e2-e558adf3932a
# ╟─52f9edd0-79b0-4a9a-9930-3a05d3aa2447
# ╟─90d5244e-17be-4601-b922-8c254f1248bf
# ╟─ae79ee89-d788-4612-8b1d-fc22d85c7744
# ╠═3745c237-ba48-4f2c-959e-441484244764
# ╟─6d061411-6f19-4119-aefb-cc380198b0ce
# ╟─8def87d2-f10b-4a82-b353-a6477eeead9b
# ╟─c74b3105-f480-4688-b85f-3e7dff70da3b
# ╠═55438c09-1d94-4ff7-90c3-0cc6064a091e
# ╟─bcc796c9-db11-4a09-a5f9-215127ac0938
# ╟─92b2ecdd-9491-4f16-8cb9-bacbcf180280
# ╠═83216915-cdcf-4f0f-829f-a5ff4c4b8da0
# ╟─452872f9-2009-4733-b2d3-28f262ae19b7
# ╟─29415ddc-e002-4f56-a169-95f7b1c36be9
# ╟─fb23d6c6-b812-4fe1-b224-0014bedbd43f
# ╠═1e53aa10-dff6-40d5-89e2-da194ffc2052
# ╠═ac87ced2-986f-4e6c-80b2-104b25c171c2
# ╠═14cca8ce-cc61-4fae-b871-21c3fd23d0ea
# ╠═28fc8de4-749b-4093-b32f-c398f8d27d3d
# ╠═57b422e5-0ad0-4674-bdd3-a8358bc7aaeb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
