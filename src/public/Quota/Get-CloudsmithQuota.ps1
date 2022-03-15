function Get-CloudsmithQuota {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter()]
        [Switch]
        $History,

        [Parameter()]
        [Switch]
        $OpenSource
    )

    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {
        
        if ($PSBoundParameters.Count -eq 1) {
            $endpoint = "quota/$Owner/"

            $result = Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

            [PSCustomObject]@{
                Raw     = @{
                    Bandwidth = @{
                        Used           = $result.usage.raw.bandwidth.used
                        Configured     = $result.usage.raw.bandwidth.Configured
                        PlanLimit      = $result.usage.raw.bandwidth.plan_limit
                        PercentageUsed = $result.usage.raw.bandwidth.percentage_used
                    }
                    Storage   = @{
                        Used           = $result.usage.storage.used
                        Configured     = $result.usage.storage.configured
                        PlanLimit      = $result.usage.storage.plan_limit
                        PercentageUsed = $result.usage.storage.percentage_used
                    }
                }
                Display = @{
                    Bandwidth = @{
                        Used           = $result.usage.display.bandwidth.used
                        Configured     = $result.usage.display.bandwidth.configured
                        PlanLimit      = $result.usage.display.bandwidth.plan_limit
                        PercentageUsed = $result.usage.display.bandwidth.percentage_used
                    }   
                    Storage   = @{
                        Used           = $result.usage.display.storage.used
                        Configured     = $result.usage.display.storage.configured
                        PlanLimit      = $result.usage.display.storage.plan_limit
                        PercentageUsed = $result.usage.display.storage.percentage_used

                    }
                }
            }
        }

        else {

            if ($OpenSource -and -not $History) {
                $endpoint = "quota/oss/$Owner/"
                $result = Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

                [PSCustomObject]@{
                    Raw     = @{
                        Bandwidth = @{
                            Used           = $result.usage.raw.bandwidth.used
                            Configured     = $result.usage.raw.bandwidth.Configured
                            PlanLimit      = $result.usage.raw.bandwidth.plan_limit
                            PercentageUsed = $result.usage.raw.bandwidth.percentage_used
                        }
                        Storage   = @{
                            Used           = $result.usage.storage.used
                            Configured     = $result.usage.storage.configured
                            PlanLimit      = $result.usage.storage.plan_limit
                            PercentageUsed = $result.usage.storage.percentage_used
                        }
                    }
                    Display = @{
                        Bandwidth = @{
                            Used           = $result.usage.display.bandwidth.used
                            Configured     = $result.usage.display.bandwidth.configured
                            PlanLimit      = $result.usage.display.bandwidth.plan_limit
                            PercentageUsed = $result.usage.display.bandwidth.percentage_used
                        }   
                        Storage   = @{
                            Used           = $result.usage.display.storage.used
                            Configured     = $result.usage.display.storage.configured
                            PlanLimit      = $result.usage.display.storage.plan_limit
                            PercentageUsed = $result.usage.display.storage.percentage_used

                        }
                    }
                }

            }
            if ($History -and -not $OpenSource) {
                $endpoint = "quota/history/$Owner/"

                $result = Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

                $result.history | Foreach-Object {
                    [pscustomobject]@{
                        Start   = $_.start
                        End     = $_.end
                        Days    = $_.days
                        Plan    = $_.plan
                        Raw     = @{
                            Uploaded    = @{
                                Used       = $_.raw.uploaded.used
                                Limit      = $_.raw.uploaded.limit
                                Percentage = $_.raw.uploaded.percentage
                            }
                            Downloaded  = @{
                                Used       = $_.raw.downloaded.used
                                Limit      = $_.raw.downloaded.limit
                                Percentage = $_.raw.downloaded.percentage
                            }
                            StorageUsed = @{
                                Used       = $_.raw.storage_used.used
                                Limit      = $_.raw.storage_used.limit
                                Percentage = $_.raw.storage_used.percentage
                            }
                        }
                        Display = @{
                            Uploaded    = @{
                                Used       = $_.display.uploaded.used
                                Limit      = $_.display.upladed.limit
                                Percentage = $_.display.uploaded.percentage
                            }
                            Downloaded  = @{
                                Used       = $_.display.downloaded.used
                                Limit      = $_.display.downloaded.limit
                                Percentage = $_.display.downloaded.percentage
                            }
                            StorageUsed = @{
                                Used       = $_.display.storage_used.used
                                Limit      = $_.display.storage_used.limit
                                Percentage = $_.display.storage_used.percentage
                            }
                        }
                    }
                }
            }

            if($OpenSource -and $History){
                $endpoint = "quota/oss/history/$Owner/"
                $result = Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

                $result.history | Foreach-Object {
                    [pscustomobject]@{
                        Start   = $_.start
                        End     = $_.end
                        Days    = $_.days
                        Plan    = $_.plan
                        Raw     = @{
                            Uploaded    = @{
                                Used       = $_.raw.uploaded.used
                                Limit      = $_.raw.uploaded.limit
                                Percentage = $_.raw.uploaded.percentage
                            }
                            Downloaded  = @{
                                Used       = $_.raw.downloaded.used
                                Limit      = $_.raw.downloaded.limit
                                Percentage = $_.raw.downloaded.percentage
                            }
                            StorageUsed = @{
                                Used       = $_.raw.storage_used.used
                                Limit      = $_.raw.storage_used.limit
                                Percentage = $_.raw.storage_used.percentage
                            }
                        }
                        Display = @{
                            Uploaded    = @{
                                Used       = $_.display.uploaded.used
                                Limit      = $_.display.upladed.limit
                                Percentage = $_.display.uploaded.percentage
                            }
                            Downloaded  = @{
                                Used       = $_.display.downloaded.used
                                Limit      = $_.display.downloaded.limit
                                Percentage = $_.display.downloaded.percentage
                            }
                            StorageUsed = @{
                                Used       = $_.display.storage_used.used
                                Limit      = $_.display.storage_used.limit
                                Percentage = $_.display.storage_used.percentage
                            }
                        }
                    }
                }
            }
        }

    }
}