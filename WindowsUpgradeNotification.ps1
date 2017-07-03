$ErrorActionPreference = "Stop"

$notificationTitle  = "Automatic WindowsUpdate"
$notificationText = "Windows Major Upgrades were found.`r`nPlease go to your update center and install them."

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText04)

#Convert to .NET type for XML manipuration
$toastXml = [xml] $template.GetXml()
$toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null

#Convert back to WinRT type
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml("<toast launch='Automatic WindowsUpdate'>
        <visual>
        <binding template='ToastImageAndText04'>
        <text id='1'>$notificationTitle</text>
        <text id='2'>$notificationText</text>
        <image id='1' src='file:///c:/admin/test.png' />
        </binding>
        </visual>
        <actions>
        <action activationType='protocol' content='Update-Center' arguments='ms-settings:windowsupdate' />
        <action activationType='system' content='' arguments='snooze' />
        </actions>
        </toast>")

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$toast.Tag = "WindowsUpdate"
$toast.Group = "WindowsUpdate"
$toast.ExpirationTime = (Get-Date).AddMinutes(10)
$toast.Activated
#$toast.SuppressPopup = $true

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($notificationTitle)
$notifier.Show($toast)