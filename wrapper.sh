# Start the first process
authenticator &
ps aux | grep authenticator | grep -v -q grep
status=$?
echo "Authenticator status: " $status
if echo $status | grep -v -q 0
then
  echo "Failed to start authenticator: " $status
  exit $status
fi

sleep 5
# Start the second process
/start_secret_grabber.sh &
ps aux | grep start_secret_grabber | grep -v -q grep
status=$?
echo "Grabber status: " $status
if echo $status | grep -v -q 0
then
  echo "Failed to start grabber: " $status
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60
do
  ps aux | grep authenticator | grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux | grep start_secret_grabber | grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if echo $PROCESS_1_STATUS | grep -v -q 0
  then
    echo "Authenticator failed."
    exit 1
  fi
  if echo $PROCESS_2_STATUS | grep -v -q 0
  then
    echo "Grabber failed."
    exit 1
  fi
done