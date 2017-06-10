# ssh login with goldenegg/lsec2 & peco
function lssh
  set IP (lsec2 $argv | peco | awk -F "\t" '{print $2}')
  if [ $status -eq 0 -a "$IP" != "" ]
      ssh "$IP"
  end
end
