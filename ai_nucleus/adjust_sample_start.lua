-- get user input
local input_ok, user_input = reaper.GetUserInputs("Sample start for Nucleus instruments", 1, "Sample Start (-ms):", "")
if not input_ok then return end

-- convert user input to number
ms = tonumber(user_input)

-- Get the number of selected tracks
numTracks = reaper.CountTracks()
paramVal = 1 - math.abs(ms/250)
-- reaper.ShowConsoleMsg(paramVal)

-- Iterate over the selected tracks
for i = 0, numTracks-1 do
  -- Get the selected track
  track = reaper.GetTrack(0, i)
  numFX = reaper.TrackFX_GetCount(track)

  if track ~= nil then
    for j = 0, numFX - 1 do
    
      -- Get the name of the FX
      retval, fxName = reaper.TrackFX_GetFXName(track, j, "")
      numParams = reaper.TrackFX_GetNumParams(track, j)
      
      for k = 0, numParams - 1 do
        _, paramName = reaper.TrackFX_GetParamName(track, j, k, "")
        if paramName == "Sample Start" then
           reaper.TrackFX_SetParam(track, j, k, paramVal)
           reaper.SetMediaTrackInfo_Value(track, "D_PLAY_OFFSET",-ms/1000)
           if ms ~= 0 then
             reaper.SetMediaTrackInfo_Value(track, "I_PLAY_OFFSET_FLAG", 0)
            else 
              reaper.SetMediaTrackInfo_Value(track, "I_PLAY_OFFSET_FLAG", 1)
            end
        end
      end
        
    
    end
    
  else
    reaper.ShowConsoleMsg("Track " .. i .. " is nil")
  end
end

