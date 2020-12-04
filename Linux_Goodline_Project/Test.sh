arguments=(
    "search"
    "search -k hello"
    "search -l ru"
    "search -k hello -l ru"
    "update Ola -k hello -l pt"
    "delete -k hello -l pt"
    "delete -k day"
    "delete -l ru"
)

testPassed=0
testFailed=0

function runTests {
./.build/debug/Linux_Goodline_Project ""${arguments[$i]}""   
exitCode="$?"
if [[ $? -eq "0" ]]; then
    let testPassed++
else
    let testFailed++
fi
}

for i in ${!arguments[@]}; do
    runTests ${arguments[$i]}
done

echo "Tests count = " ${#arguments[@]};
echo "Tests Failed = " $testFailed
echo "Tests Passed = " $testPassed