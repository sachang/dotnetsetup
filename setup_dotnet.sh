mkdir $1
# setup the projects
cd $1
dotnet new sln --name "$1"
dotnet new classlib --name "$1.Core"
dotnet sln add "$1.Core"
dotnet new nunit --name "$1.Tests"
dotnet sln add "$1.Tests"
cd "$1.Tests"
dotnet add reference ../$1.Core

# rename files, add interface, rename classes
cd "../$1.Core"
mv Class1.cs "${1}Service.cs"
cat <<EOF > "I${1}Service.cs"
namespace $1.Core;

public interface I${1}Service
{
    // implement methods
}
EOF
sed -i "s/public class Class1/public class ${1}Service : I${1}Service/" "${1}Service.cs"

cd "../$1.Tests"
mv UnitTest1.cs $1ServiceTests.cs
sed -i "1s/^/using ${1}.Core;\n\n/" "${1}ServiceTests.cs"
sed -i "s/public class Tests/public class ${1}ServiceTests/" "${1}ServiceTests.cs"

# start up VS Code
cd ../
code .