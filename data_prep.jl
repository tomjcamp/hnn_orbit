f = open("filenamehere", "r")

file = readlines(f)

data = file[23:length(file) - 1]

traj = []
dates = []
positions = []
velocities = []

for i in 1:length(data)
    if 1 == i % 65
        push!( dates,data[i])
    else
        push!(traj,data[i])
    end

end

for i in 1:length(traj)
    if 1 == i % 2
        push!( positions,traj[i])
    else
        push!(velocities,traj[i])
    end

end

pos_arr = Array{Float64}[]
vel_arr = Array{Float64}[]

for i in 1:length(positions)
    sp = split(positions[i])

    push!(pos_arr, parse.(Float64, sp[2:5]))
end

for i in 1:length(velocities)
    sp = split(velocities[i])
    push!(pos_arr, parse.(Float64, sp[2:5]))
end

pos_arr
prn_1_pos = [pos_arr[i,:] for i in 1: length(pos_arr) if pos_arr[i][1] == 1.0]

hcat(prn_1_pos, dates)
