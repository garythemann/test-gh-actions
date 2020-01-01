.PHONY: dotnet/build dotnet/test dotnet/publish dotnet/push

CONFIGURATION ?= Release

dotnet/restore:
	dotnet restore

dotnet/build: dotnet/restore -dotnet/build
dotnet/pack: dotnet/build -dotnet/pack

-dotnet/build:
	dotnet build --configuration $(CONFIGURATION) --no-restore

-dotnet/pack:
	dotnet pack --configuration $(CONFIGURATION) --no-build

dotnet/push:
		echo "<configuration />" > nuget.config
		nuget source add -Name "GPR" \
										 -Source $(NUGET_SOURCE_URL) \
										 -UserName $(NUGET_USER_NAME) \
										 -Password $(NUGET_PASSWORD) \
										 -ConfigFile nuget.config \
										 -StorePasswordInClearText
		dotnet nuget push ./bin/Release/*.nupkg --source $(NUGET_SOURCE_URL)
