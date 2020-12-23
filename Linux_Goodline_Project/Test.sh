arguments=(
    "search"
    "search -k hello"
    "search -l ru"
    "search -k hello -l ru"
    "update Ola -k hello -l pt"
    "delete -k hello -l pt"
    "delete -k day"
    "delete -l ru"
    "search -k ju"
    "search -l py"
    "search -k ju -l ju"
    "search -k hello -l ki"
    "search -k ii -l ru"
    "search-k"
    "searchy"
    "search -j"
    "updatee"
    "update -k hllo -l pt"
    "update Ola -k"
    "update Ola -l ru -k"
    "update Ola -k hello"
    "update Ola -k hello -l"
    "delete -k someWord -l someWord"
    "delete -k someWord"
    "delete -l someWord"
    "deletet"
    "delete -k"
    "delete -l"
    "delete-k hello"
)

exitCodeProject=(0 0 0 0 0 0 0 0 2 3 1 1 1 100 100 100 100 100 100 100 100 100 9 10 11 100 100 100 100)

testPassed=0
testFailed=0

function runTests {
exitCode=${exitCodeProject[$i]}
./.build/debug/Project_Run ""${arguments[$i]}""  
exitCodeNow=$? 
if [ $exitCodeNow -eq $exitCode ]; then
    let testPassed++
else
    let testFailed++
    echo "Test $i with arguments:"" ${arguments[$i]} "" - failed"
fi
}

for i in ${!arguments[@]}; do
    runTests ${arguments[$i]}
done

echo "Tests count = " ${#arguments[@]};
echo "Tests Failed = " $testFailed
echo "Tests Passed = " $testPassed

if [ $testFailed -eq 0 ]; then
  exit 0
else
  exit 1
fi