# Test API Endpoints

## Prerequisites
Make sure the server is running on http://localhost:3000

## 1. Health Check

```bash
curl http://localhost:3000/health
```

## 2. Test Folder Selection and File Listing

Create a test folder with some files first:

```powershell
# Create test folder and files
New-Item -ItemType Directory -Force -Path "E:\TestFiles"
"Test content 1" | Out-File "E:\TestFiles\document1.txt"
"Test content 2" | Out-File "E:\TestFiles\document2.txt"
"Sample PDF content" | Out-File "E:\TestFiles\report.pdf"
```

Then list files from the folder:

```bash
curl -X POST http://localhost:3000/api/files/list-folder ^
  -H "Content-Type: application/json" ^
  -d "{\"folderPath\":\"E:\\\\TestFiles\"}"
```

## 3. Test Upload Files

```bash
curl -X POST http://localhost:3000/api/files/upload ^
  -H "Content-Type: application/json" ^
  -d @test-upload.json
```

Where `test-upload.json` contains the files from step 2.

## 4. Get Upload Statistics

```bash
curl http://localhost:3000/api/files/stats
```

## Using PowerShell (Windows)

### Health Check
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/health" -Method GET
```

### List Files
```powershell
$body = @{
    folderPath = "E:\TestFiles"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body
```

### Upload Files
```powershell
# First, get the files list
$filesResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method POST `
    -ContentType "application/json" `
    -Body (@{ folderPath = "E:\TestFiles" } | ConvertTo-Json)

# Then upload them
$uploadBody = @{
    files = $filesResponse.files
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "http://localhost:3000/api/files/upload" `
    -Method POST `
    -ContentType "application/json" `
    -Body $uploadBody
```

### Get Stats
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/files/stats" -Method GET
```
