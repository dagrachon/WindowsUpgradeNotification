#used in https://github.com/dagrachon/windows_update_script
$ErrorActionPreference = "Stop"

$notificationTitle = "Windows Major Upgrades were found.`r`nPlease go to your update center and install them."

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

#Convert to .NET type for XML manipuration
$toastXml = [xml] $template.GetXml()
$toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null

#Convert back to WinRT type
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($toastXml.OuterXml)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$toast.Tag = "WindowsUpdate"
$toast.Group = "WindowsUpdate"
$toast.ExpirationTime = (Get-Date).AddMinutes(10)
$toast.Activated
#$toast.SuppressPopup = $true

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Automatic WindowsUpdate")
$notifier.Show($toast)