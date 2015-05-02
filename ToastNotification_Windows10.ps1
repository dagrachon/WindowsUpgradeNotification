$ErrorActionPreference = "Stop"

$notificationTitle = "Notification: " + [DateTime]::Now.ToShortTimeString()

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

#Convert to .NET type for XML manipuration
$toastXml = [xml] $template.GetXml()
$toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null

#Convert back to WinRT type
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($toastXml.OuterXml)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$toast.Tag = "PowerShell"
$toast.Group = "PowerShell"
$toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(5)
#$toast.SuppressPopup = $true

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
$notifier.Show($toast);

<#
$toasts = [Windows.UI.Notifications.ToastNotificationManager]::History.GetHistory()
if ($toast -ne $null)
{
    $count = $toasts.Count()
    [TileServices]::SetBadgeCountOnTile($count)

    $badgeXml = [Windows.UI.Notifications.BadgeUpdateManager]::GetTemplateContent([Windows.UI.Notifications.BadgeTemplateType]::BadgeNumber)
    $badgeXml.badge.value = $count.ToString()
    $badge = [Windows.UI.Notifications.BadgeNotification]::new($badgeXml)
    [Windows.UI.Notifications.BadgeUpdateManager]::CreateBadgeUpdaterForApplication().Update($badge)
}
#>