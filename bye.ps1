#Load the GDI+ and WinForms Assemblies
[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null

# Create pen and brush objects
$myBrush = new-object Drawing.SolidBrush green
$mypen = new-object Drawing.Pen black

# Create a Rectangle object for use when drawing rectangle
$rect = new-object Drawing.Rectangle 10, 10, 180, 180

# Create a Form
$form = New-Object Windows.Forms.Form
$form.Text = "Async Key Input Demo"
$form.Size = New-Object Drawing.Size(800, 600)

# *** The TWO Key Steps for Input ***
# 1. Set KeyPreview to $true so the Form receives key events first
$form.KeyPreview = $true 

# 2. Define the KeyDown handler (This is your "async" input method)
$form.Add_KeyDown({
    param([object]$sender, [System.Windows.Forms.KeyEventArgs]$e)

    # The $e object contains the KeyCode
    Write-Host "Key Pressed: $($e.KeyCode)"

    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
        Write-Host "Escape key pressed. Closing form."
        $form.Close()
    }
})
# ***********************************
$backgroundColor = [System.Drawing.Color]::White # You can change this color
# Define the Paint handler (existing drawing code)
$form.add_paint({
    param([object]$sender, [System.Windows.Forms.PaintEventArgs]$_)
    

    $g = $_.Graphics
    
    # 2. <<< CLEAR THE SCREEN HERE >>>
    # This wipes the entire drawing surface with the specified color
    $g.Clear($backgroundColor)

    $mypen.color = "red"
    $mypen.width = 5
    
    $_.Graphics.FillRectangle($myBrush, $rect)
    $_.Graphics.DrawRectangle($mypen, $rect)
})

# Display the form using Show() for non-blocking execution
$form.Show()

Write-Host "hi"
Write-Host "Code continues to run here while the form is open and waiting for key events." 

# To keep the script and form open until the form is closed, you need a message loop.
# This is a common way to implement a non-blocking form in PowerShell.
while ($form.Visible) {
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 10
}