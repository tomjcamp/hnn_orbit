using Dates, DataFrames, ShiftedArrays, CSV
f = open("C:/Users/tom_j/Downloads/center_of_mass/nga22121.eph", "r")

file = readlines(f)

data = file[23:length(file)-1]

traj = []
dates = []
positions = []
velocities = []

for i in 1:length(data)
    if 1 == i % 65
        push!(dates, data[i])
    else
        push!(traj, data[i])
    end

end

for i in 1:length(traj)
    if 1 == i % 2
        push!(positions, traj[i])
    else
        push!(velocities, traj[i])
    end

end

positions
velocities

pos_arr = Array{Float64}[]
vel_arr = Array{Float64}[]

for i in 1:length(positions)
    sp = split(positions[i])

    push!(pos_arr, parse.(Float64, sp[2:5]))
end

for i in 1:length(velocities)
    sp = split(velocities[i])
    push!(vel_arr, parse.(Float64, sp[2:5]))
end

pos_arr

prn_1_pos = []
prn_1_vel = []

for i in 1:length(pos_arr)
    if pos_arr[i][1] == 1.0
        push!(prn_1_pos, pos_arr[i])
    end
end

for i in 1:length(vel_arr)
    if vel_arr[i][1] == 1.0
        push!(prn_1_vel, vel_arr[i])
    end
end

date_vec = []

for i in 1:length(dates)
    sp = split(dates[i])
    push!(date_vec, parse.(Int64, sp[2:6]))
end

years = [date_vec[i][1] for i in 1:length(date_vec)]
months = [date_vec[i][2] for i in 1:length(date_vec)]
days = [date_vec[i][3] for i in 1:length(date_vec)]
hours = [date_vec[i][4] for i in 1:length(date_vec)]
minutes = [date_vec[i][5] for i in 1:length(date_vec)]


dt = DateTime.(Dates.Year.(years),
    Dates.Month.(months),
    Dates.Day.(days),
    Dates.Hour.(hours),
    Dates.Minute.(minutes))


pos_df = DataFrame(mapreduce(permutedims, vcat, prn_1_pos), :auto)
vel_df = DataFrame(mapreduce(permutedims, vcat, prn_1_vel), :auto)

posnames = ["prn", "x_pos", "y_pos", "z_pos"]
velnames = ["prn", "x_vel", "y_vel", "z_vel"]

rename!(vel_df, Symbol.(velnames))
rename!(pos_df, Symbol.(posnames))

select!(pos_df, Not(:prn))
select!(vel_df, Not(:prn))

full_df = hcat(pos_df, vel_df)

full_df.dt = dt

full_df.x_vel_diff = (full_df.x_vel - lag(full_df.x_vel))
full_df.y_vel_diff = (full_df.y_vel - lag(full_df.y_vel))
full_df.z_vel_diff = (full_df.z_vel - lag(full_df.z_vel))

full_df.x_pos_diff = (full_df.x_pos - lag(full_df.x_pos))
full_df.y_pos_diff = (full_df.y_pos - lag(full_df.y_pos))
full_df.z_pos_diff = (full_df.z_pos - lag(full_df.z_pos))


dropmissing!(full_df)

CSV.write("C:/Users/tom_j/Documents/nga22121_df.csv", full_df)
