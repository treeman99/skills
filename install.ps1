<#
.SYNOPSIS
  이 저장소의 skills/ 폴더를 Orca 워커가 읽는 스킬 홈에 설치한다.

.DESCRIPTION
  ~/.agents/skills 에는 항상 설치한다 (Orca가 "Agent skills home"으로 인식하는 공용 경로).
  ~/.claude/skills, ~/.config/opencode/skills 는 해당 디렉터리가 이미 있을 때만 설치한다.
  없는 에이전트의 설정 디렉터리를 새로 만들지 않기 위해서다. -All 을 주면 전부 만든다.

.PARAMETER All
  에이전트 홈이 없어도 전부 생성해서 설치한다.

.PARAMETER DryRun
  실제로 복사하지 않고 무엇을 할지만 출력한다.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -All
  .\install.ps1 -DryRun
#>
[CmdletBinding()]
param(
    [switch]$All,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$RepoRoot  = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $RepoRoot 'skills'

if (-not (Test-Path -LiteralPath $SourceDir)) {
    Write-Error "skills 폴더를 찾을 수 없습니다: $SourceDir"
}

$Skills = Get-ChildItem -LiteralPath $SourceDir -Directory |
          Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

if ($Skills.Count -eq 0) {
    Write-Error "설치할 스킬이 없습니다. skills/<name>/SKILL.md 구조를 확인하세요."
}

Write-Host "설치할 스킬 $($Skills.Count)개: $($Skills.Name -join ', ')" -ForegroundColor Cyan
Write-Host ""

$Home_ = $env:USERPROFILE
if (-not $Home_) { $Home_ = $HOME }

# 공용 경로는 항상, 에이전트별 경로는 존재할 때만 (-All 이면 전부)
$Targets = @(
    @{ Label = 'Agent skills home'; Path = Join-Path $Home_ '.agents\skills';          Always = $true  },
    @{ Label = 'Claude home';       Path = Join-Path $Home_ '.claude\skills';          Always = $false },
    @{ Label = 'OpenCode home';     Path = Join-Path $Home_ '.config\opencode\skills'; Always = $false }
)

$installedAny = $false

foreach ($t in $Targets) {
    $parent = Split-Path -Parent $t.Path
    $exists = (Test-Path -LiteralPath $t.Path) -or (Test-Path -LiteralPath $parent)

    if (-not $t.Always -and -not $exists -and -not $All) {
        Write-Host "건너뜀  $($t.Label): $($t.Path) (미설치 에이전트)" -ForegroundColor DarkGray
        continue
    }

    Write-Host "설치    $($t.Label): $($t.Path)" -ForegroundColor Green

    if (-not $DryRun -and -not (Test-Path -LiteralPath $t.Path)) {
        New-Item -ItemType Directory -Path $t.Path -Force | Out-Null
    }

    foreach ($s in $Skills) {
        $dest = Join-Path $t.Path $s.Name

        if ($DryRun) {
            Write-Host "          [dry-run] $($s.Name)"
            continue
        }

        # 같은 이름의 기존 스킬은 통째로 교체한다. 남은 파일이 섞이면
        # 상류에서 제거된 참조 문서가 살아남아 스킬이 없는 파일을 가리킨다.
        if (Test-Path -LiteralPath $dest) {
            Remove-Item -LiteralPath $dest -Recurse -Force
        }
        Copy-Item -LiteralPath $s.FullName -Destination $dest -Recurse -Force
        Write-Host "          $($s.Name)"
    }

    $installedAny = $true
    Write-Host ""
}

if (-not $installedAny) {
    Write-Warning "설치된 곳이 없습니다. -All 로 다시 실행하세요."
    exit 1
}

if ($DryRun) {
    Write-Host "dry-run 이었습니다. 실제로 설치하려면 -DryRun 없이 실행하세요." -ForegroundColor Yellow
    exit 0
}

Write-Host "완료. 확인:" -ForegroundColor Cyan
Write-Host "  orca skills installed | Select-String 'karpathy|test-driven|systematic-debug|verification-before'"
Write-Host ""
Write-Host "orchestration 라우팅이 실렸는지 확인:" -ForegroundColor Cyan
Write-Host "  Select-String -Path `"$(Join-Path $Home_ '.agents\skills\orchestration\SKILL.md')`" -Pattern 'QUALITY CONTRACT'"
