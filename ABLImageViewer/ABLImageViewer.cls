 
/*------------------------------------------------------------------------
   File        : ABLImageViewer.cls
   Purpose     : Proof of concept to handle images in the ABL using .NET
   Syntax      : 
   Description : 
   Author(s)   : James Bowen    
   Created     : 13/10/2023
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Windows.Form from assembly.
using System.Drawing.Bitmap from assembly.
using System.Drawing.Color from assembly.
using System.Drawing.Drawing2D.Matrix from assembly.
using System.Drawing.Graphics from assembly.
using System.Drawing.Image from assembly.
using System.Drawing.Imaging.FrameDimension from assembly.
using System.Drawing.Point from assembly.
using System.Drawing.PointF from assembly.
using System.Drawing.Size from assembly.
using System.Windows.Forms.Control from assembly.
using System.Windows.Forms.Cursor from assembly.
using System.Windows.Forms.DialogResult from assembly.
using System.Windows.Forms.Keys from assembly.
using System.Windows.Forms.MouseButtons from assembly.
using System.Windows.Forms.SaveFileDialog from assembly.

//Susing System.Drawing.Drawing2D.Matrix.

class ABLImageViewer inherits Form: 
	
    define private variable bntSaveAs   as System.Windows.Forms.Button      no-undo.
    define private variable button2     as System.Windows.Forms.Button      no-undo.
    define private variable button3     as System.Windows.Forms.Button      no-undo.
    define private variable components  as System.ComponentModel.IContainer no-undo.
    define private variable imageList1  as System.Windows.Forms.ImageList   no-undo.
    define private variable panel2      as System.Windows.Forms.Panel       no-undo.
    define private variable pictureBox1 as System.Windows.Forms.PictureBox  no-undo.
    define private variable textBox1    as System.Windows.Forms.TextBox     no-undo.
    define private variable vScrollBar1 as System.Windows.Forms.VScrollBar  no-undo.
		
    define private property currentPage as integer no-undo 
        get.
        set. 

    define private property lastMousePos as class Point  no-undo 
        get.
        set. 

    define private property isPanning as logical no-undo 
        get.
        set. 

    define private property originalImage as class System.Drawing.Image no-undo 
        get.
        set. 

    define private property pageCount as integer no-undo 
        get.
        set. 

    define private property pictureboxFocus as logical no-undo 
        get.
        set. 

    define private property transformationMatrix as class Matrix  no-undo 
        get.
        set. 

    define private property zoomPoint as class PointF  no-undo 
        get.
        set. 

    constructor public ABLImageViewer (  ):

        InitializeComponent().
        this-object:ComponentsCollection:Add(this-object:components).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.

    end constructor.


    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void bntSaveAs_Click( input sender as System.Object, input e as System.EventArgs ):
		
        define variable saveFileDialog  as class SaveFileDialog no-undo.
        define variable dialogResult    as class DialogResult   no-undo.
        define variable tempBitmapImage as class Bitmap         no-undo.
		
        if valid-object( pictureBox1:Image) then
        do:
		    
            saveFileDialog = new SaveFileDialog().
            saveFileDialog:Filter = "JPEG Image|*.jpg|PNG Image|*.png|Bitmap Image|*.bmp".
            
            wait-for saveFileDialog:ShowDialog() set dialogResult.
            
            if ( dialogResult = System.Windows.Forms.DialogResult:OK) then
            do:
                tempBitmapImage = new Bitmap(pictureBox1:Image).
                tempBitmapImage:Save(saveFileDialog:FileName).
            end.
        end.
        
        return.
    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void button2_Click( input sender as System.Object, input e as System.EventArgs ):
		
        RotateImageCounterClockwise().
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void button3_Click( input sender as System.Object, input e as System.EventArgs ):
		
        RotateImageCounterAntiClockwise().
        
     	
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void CloseImage(  ):
        
        if valid-object(originalImage) then
        do:
            pictureBox1:Image = ?. 
            
            originalImage:Dispose().
               
            delete object originalImage.
        end. 
        
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void Form1_Load( input sender as System.Object, input e as System.EventArgs ):
		
		
        define variable newImage as class System.Drawing.Image no-undo.
		
        newImage = Image:FromFile( "NewtonsCradle.tif").
        
		this-object:CloseImage().
		
        originalImage = newImage.
		
        pageCount = GetPageCount(input newImage).
		
        if pageCount ne 0 then
        do:
            vScrollBar1:Minimum = 1.
            vScrollBar1:Maximum = pageCount.
            vScrollBar1:Enabled = true.
        end.
        else
            vScrollBar1:Enabled = false.
		
        pictureBox1:Image = newImage.
		
        transformationMatrix = new Matrix().
		
        zoomPoint = PointF:Empty.
        
     
		
		//pictureBox1:SizeMode = PictureBoxSizeMode:StretchImage.   
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private static integer GetPageCount(input imageObj as class System.Drawing.Image  ):
        
        define variable result    as integer no-undo.
        define variable dimension as class   System.Drawing.Imaging.FrameDimension no-undo.
        
        dimension = System.Drawing.Imaging.FrameDimension:Page. 
        
        return imageObj:GetFrameCount(dimension).
        
    end method.

    method private void InitializeComponent(  ):
		
        /* NOTE: The following method is automatically generated.
            
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
            
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("Form1").
        this-object:imageList1 = new System.Windows.Forms.ImageList(this-object:components).
        this-object:vScrollBar1 = new System.Windows.Forms.VScrollBar().
        this-object:textBox1 = new System.Windows.Forms.TextBox().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:panel2 = new System.Windows.Forms.Panel().
        this-object:pictureBox1 = new System.Windows.Forms.PictureBox().
        this-object:button3 = new System.Windows.Forms.Button().
        this-object:bntSaveAs = new System.Windows.Forms.Button().
        this-object:panel2:SuspendLayout().
        cast(this-object:pictureBox1, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* imageList1 */
        /*  */
        this-object:imageList1:ImageStream = cast(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageList1:Images:SetKeyName(0, "addcomponents.ico").
        this-object:imageList1:Images:SetKeyName(1, "admin%.ico").
        this-object:imageList1:Images:SetKeyName(2, "Audit.ico").
        this-object:imageList1:Images:SetKeyName(3, "characterclient.ico").
        this-object:imageList1:Images:SetKeyName(4, "client.ico").
        this-object:imageList1:Images:SetKeyName(5, "clusterconfig.ico").
        this-object:imageList1:Images:SetKeyName(6, "comp%.ico").
        this-object:imageList1:Images:SetKeyName(7, "dbconfig.ico").
        this-object:imageList1:Images:SetKeyName(8, "debug%.ico").
        this-object:imageList1:Images:SetKeyName(9, "desktop.ico").
        this-object:imageList1:Images:SetKeyName(10, "dict%.ico").
        this-object:imageList1:Images:SetKeyName(11, "edit%.ico").
        this-object:imageList1:Images:SetKeyName(12, "firststeps.ico").
        this-object:imageList1:Images:SetKeyName(13, "help%.ico").
        this-object:imageList1:Images:SetKeyName(14, "icfdcu.ico").
        this-object:imageList1:Images:SetKeyName(15, "icfdev.ico").
        this-object:imageList1:Images:SetKeyName(16, "icfdevas.ico").
        this-object:imageList1:Images:SetKeyName(17, "icfrt.ico").
        this-object:imageList1:Images:SetKeyName(18, "install_OEBPS.ico").
        this-object:imageList1:Images:SetKeyName(19, "licenseinfo.ico").
        this-object:imageList1:Images:SetKeyName(20, "licenseupdate.ico").
        this-object:imageList1:Images:SetKeyName(21, "monitor_OEBPS.ico").
        this-object:imageList1:Images:SetKeyName(22, "ntservice.ico").
        this-object:imageList1:Images:SetKeyName(23, "oeide.ico").
        this-object:imageList1:Images:SetKeyName(24, "portalserver.ico").
        this-object:imageList1:Images:SetKeyName(25, "Proenv.ico").
        this-object:imageList1:Images:SetKeyName(26, "progress.ico").
        this-object:imageList1:Images:SetKeyName(27, "proserve.ico").
        this-object:imageList1:Images:SetKeyName(28, "proshut.ico").
        this-object:imageList1:Images:SetKeyName(29, "proxygen.ico").
        this-object:imageList1:Images:SetKeyName(30, "rbuild%.ico").
        this-object:imageList1:Images:SetKeyName(31, "releasenotes.ico").
        this-object:imageList1:Images:SetKeyName(32, "report%.ico").
        this-object:imageList1:Images:SetKeyName(33, "results%.ico").
        this-object:imageList1:Images:SetKeyName(34, "sbm_pm16.ico").
        this-object:imageList1:Images:SetKeyName(35, "sbmejb.ico").
        this-object:imageList1:Images:SetKeyName(36, "startdbs.ico").
        this-object:imageList1:Images:SetKeyName(37, "startejb.ico").
        this-object:imageList1:Images:SetKeyName(38, "startportal.ico").
        this-object:imageList1:Images:SetKeyName(39, "stopdbs.ico").
        this-object:imageList1:Images:SetKeyName(40, "stopejb.ico").
        this-object:imageList1:Images:SetKeyName(41, "stopportal.ico").
        this-object:imageList1:Images:SetKeyName(42, "tran%.ico").
        this-object:imageList1:Images:SetKeyName(43, "trans%.ico").
        this-object:imageList1:Images:SetKeyName(44, "uib%.ico").
        this-object:imageList1:Images:SetKeyName(45, "uninstall_OEBPS.ico").
        this-object:imageList1:Images:SetKeyName(46, "unprog.ico").
        this-object:imageList1:Images:SetKeyName(47, "userconfig.ico").
        this-object:imageList1:Images:SetKeyName(48, "versioninfo.ico").
        this-object:imageList1:Images:SetKeyName(49, "vtrans%.ico").
        this-object:imageList1:Images:SetKeyName(50, "workshp%.ico").
        /*  */
        /* vScrollBar1 */
        /*  */
        define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
        nestedvar0 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles).
        this-object:vScrollBar1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        this-object:vScrollBar1:LargeChange = 1.
        this-object:vScrollBar1:Location = new System.Drawing.Point(0, 0).
        this-object:vScrollBar1:Maximum = 1.
        this-object:vScrollBar1:Name = "vScrollBar1".
        this-object:vScrollBar1:Size = new System.Drawing.Size(18, 562).
        this-object:vScrollBar1:TabIndex = 3.
        this-object:vScrollBar1:Scroll:Subscribe(this-object:vScrollBar1_Scroll).
        /*  */
        /* textBox1 */
        /*  */
        this-object:textBox1:Location = new System.Drawing.Point(42, 522).
        this-object:textBox1:Name = "textBox1".
        this-object:textBox1:ReadOnly = true.
        this-object:textBox1:Size = new System.Drawing.Size(67, 20).
        this-object:textBox1:TabIndex = 4.
        this-object:textBox1:TextAlign = System.Windows.Forms.HorizontalAlignment:Center.
        /*  */
        /* button2 */
        /*  */
        this-object:button2:Location = new System.Drawing.Point(254, 612).
        this-object:button2:Name = "button2".
        this-object:button2:Size = new System.Drawing.Size(109, 24).
        this-object:button2:TabIndex = 6.
        this-object:button2:Text = "Rotate 90 ".
        this-object:button2:UseCompatibleTextRendering = true.
        this-object:button2:UseVisualStyleBackColor = true.
        this-object:button2:Click:Subscribe(this-object:button2_Click).
        /*  */
        /* panel2 */
        /*  */
        define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
        nestedvar1 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles).
        this-object:panel2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        this-object:panel2:AutoSize = true.
        this-object:panel2:Controls:Add(this-object:textBox1).
        this-object:panel2:Controls:Add(this-object:vScrollBar1).
        this-object:panel2:Location = new System.Drawing.Point(774, 24).
        this-object:panel2:Name = "panel2".
        this-object:panel2:Size = new System.Drawing.Size(244, 561).
        this-object:panel2:TabIndex = 9.
        /*  */
        /* pictureBox1 */
        /*  */
        this-object:pictureBox1:BackgroundImageLayout = System.Windows.Forms.ImageLayout:Center.
        this-object:pictureBox1:BorderStyle = System.Windows.Forms.BorderStyle:Fixed3D.
        this-object:pictureBox1:Cursor = System.Windows.Forms.Cursors:Hand.
        this-object:pictureBox1:ErrorImage = cast(resources:GetObject("pictureBox1.ErrorImage"), System.Drawing.Image).
        this-object:pictureBox1:Location = new System.Drawing.Point(12, 24).
        this-object:pictureBox1:Name = "pictureBox1".
        this-object:pictureBox1:Size = new System.Drawing.Size(756, 562).
        this-object:pictureBox1:SizeMode = System.Windows.Forms.PictureBoxSizeMode:CenterImage.
        this-object:pictureBox1:TabIndex = 7.
        this-object:pictureBox1:TabStop = false.
        this-object:pictureBox1:Click:Subscribe(this-object:pictureBox1_Click).
        this-object:pictureBox1:Paint:Subscribe(this-object:pictureBox1_Paint).
        this-object:pictureBox1:MouseDown:Subscribe(this-object:pictureBox1_MouseDown).
        this-object:pictureBox1:MouseMove:Subscribe(this-object:pictureBox1_MouseMove).
        this-object:pictureBox1:MouseUp:Subscribe(this-object:pictureBox1_MouseUp).
        /*  */
        /* button3 */
        /*  */
        this-object:button3:Location = new System.Drawing.Point(139, 612).
        this-object:button3:Name = "button3".
        this-object:button3:Size = new System.Drawing.Size(109, 24).
        this-object:button3:TabIndex = 10.
        this-object:button3:Text = "Rotate -90 ".
        this-object:button3:UseCompatibleTextRendering = true.
        this-object:button3:UseVisualStyleBackColor = true.
        this-object:button3:Click:Subscribe(this-object:button3_Click).
        /*  */
        /* bntSaveAs */
        /*  */
        this-object:bntSaveAs:Location = new System.Drawing.Point(469, 612).
        this-object:bntSaveAs:Name = "bntSaveAs".
        this-object:bntSaveAs:Size = new System.Drawing.Size(86, 24).
        this-object:bntSaveAs:TabIndex = 11.
        this-object:bntSaveAs:Text = "Save As".
        this-object:bntSaveAs:UseCompatibleTextRendering = true.
        this-object:bntSaveAs:UseVisualStyleBackColor = true.
        this-object:bntSaveAs:Click:Subscribe(this-object:bntSaveAs_Click).
        /*  */
        /* Form1 */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(1027, 673).
        this-object:Controls:Add(this-object:bntSaveAs).
        this-object:Controls:Add(this-object:button3).
        this-object:Controls:Add(this-object:pictureBox1).
        this-object:Controls:Add(this-object:panel2).
        this-object:Controls:Add(this-object:button2).
        this-object:DoubleBuffered = true.
        this-object:Name = "Form1".
        this-object:Text = "ABL Image Viewer".
        this-object:Load:Subscribe(this-object:Form1_Load).
        this-object:panel2:ResumeLayout(false).
        this-object:panel2:PerformLayout().
        cast(this-object:pictureBox1, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        this-object:PerformLayout().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    method override protected void OnMouseWheel( input ea as System.Windows.Forms.MouseEventArgs ):
        
        //super:OnMouseWheel(input ea).
        
        define variable zoomFactor            as decimal no-undo.
        define variable newWidth              as integer no-undo.
        define variable newHeight             as integer no-undo.
        define variable offsetX               as integer no-undo.
        define variable offsetY               as integer no-undo.
        define variable fixedViewportX        as integer no-undo.
        define variable fixedViewportY        as integer no-undo.
        
        define variable fixedViewportLocation as class   Point no-undo.
        define variable fixedViewportSize     as class   Size  no-undo.
        
        fixedViewportLocation = new Point(0,0).
        fixedViewportSize = new Size(600, 400).
        

        define variable mousePos as class Point no-undo.
        
        if (Control:ModifierKeys = Keys:Control) then
        do:
            
            mousePos = pictureBox1:PointToClient(cursor:Position).
            
            if ea:Delta gt 0 then 
                ZoomIn(input mousePos).
            
            if ea:Delta lt 0 then
                ZoomOut(input mousePos).
                
        end.
        
    end method.



    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void pictureBox1_Click( input sender as System.Object, input e as System.EventArgs ):
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void pictureBox1_MouseDown( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
		
        if (e:Button = MouseButtons:Left) then
        do:
            isPanning = true.
            lastMousePos = e:Location.
        end.
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void pictureBox1_MouseMove( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
		
        define variable deltaX as integer no-undo.
        define variable deltaY as integer no-undo.
        define variable g      as class   Graphics no-undo.
		
        if (isPanning) then
        do:
            assign
                deltaX = e:X - lastMousePos:X
                deltaY = e:Y - lastMousePos:Y.
                
            transformationMatrix:Translate(deltaX, deltaY).
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation

            
            
            assign
                lastMousePos = e:Location.
                
            delete object g.    
        end.
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void pictureBox1_MouseUp( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
		
        if (e:Button = MouseButtons:Left) then
            assign
                isPanning = false.
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void pictureBox1_Paint( input sender as System.Object, input e as System.Windows.Forms.PaintEventArgs ):
		
		 
        e:Graphics:Clear(Color:White). // Clear the PictureBox
        e:Graphics:Transform = transformationMatrix. // Apply the transformation matrix
        e:Graphics:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
		
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void RotateImage( input angle as integer  ):
        
        define variable g           as class Graphics no-undo.
        define variable imageCenter as class PointF   no-undo.
        
        if valid-object(originalImage) then
        do: 
            imageCenter = new PointF(originalImage:Width / 2, originalImage:Height / 2).
            
            transformationMatrix:Translate(imageCenter:X, imageCenter:Y).
            transformationMatrix:Rotate(angle).
            transformationMatrix:Translate(imageCenter:X * -1, imageCenter:Y * -1).
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
         
            //pictureBox1:Invalidate().
            
            delete object imageCenter.
            
            delete object g.
        end.
                    
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void RotateImageCounterAntiClockwise(  ):
        
        define variable g           as class Graphics no-undo.
        define variable imageCenter as class PointF   no-undo.
        
        if valid-object(originalImage) then
        do: 
            imageCenter = new PointF(originalImage:Width / 2, originalImage:Height / 2).
            
            transformationMatrix:Translate(imageCenter:X, imageCenter:Y).
            transformationMatrix:Rotate(-90).
            transformationMatrix:Translate(imageCenter:X * -1, imageCenter:Y * -1).
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
         
            //pictureBox1:Invalidate().
            
            delete object imageCenter.
            
            delete object g.
        end.
                    
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void RotateImageCounterClockwise(  ):
        
        define variable g           as class Graphics no-undo.
        define variable imageCenter as class PointF   no-undo.
        
        if valid-object(originalImage) then
        do: 
            imageCenter = new PointF(originalImage:Width / 2, originalImage:Height / 2).
            
            transformationMatrix:Translate(imageCenter:X, imageCenter:Y).
            transformationMatrix:Rotate(90).
            transformationMatrix:Translate(imageCenter:X * -1, imageCenter:Y * -1).
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
         
            //pictureBox1:Invalidate().
            
            delete object imageCenter.
            
            delete object g.
        end.
                    
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private  void ShowPage(input iPageNumber as integer):
        
        
        this-object:currentPage = iPageNumber.
        
        originalImage:SelectActiveFrame(FrameDimension:Page, iPageNumber - 1).
        
        textBox1:Text = string(iPageNumber).
        
        // The ImageBox control doesn't know the image 
      // has changed, so force a repaint
        pictureBox1:Invalidate().
        
        return.

    end method.



    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void vScrollBar1_Scroll( input sender as System.Object, input e as System.Windows.Forms.ScrollEventArgs ):
		
		
        ShowPage(input e:NewValue ).
		//ShowPage(vScrollBar1:Value).
		
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void ZoomIn(zoomCenter as class Point  ):
        
        define variable zoomFactor  as decimal no-undo initial 1.1.
        
        define variable newWidth    as integer no-undo.
        define variable newHeight   as integer no-undo.
        
        define variable zoomedImage as class   Image    no-undo.
        define variable g           as class   Graphics no-undo.
        
        
        
        if valid-object(pictureBox1:Image) then
        do:
            
            // Zoom in by a factor of 1.1 (adjust as needed)
            transformationMatrix:Translate(zoomCenter:X, zoomCenter:Y).
            transformationMatrix:Scale(zoomFactor, zoomFactor). // Zoom in
            transformationMatrix:Translate(zoomCenter:X * -1, zoomCenter:Y * -1). // Move the image back
            
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
            
            delete object g.
            
        end.
        
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private void ZoomOut( zoomCenter as class Point ):
        
        define variable zoomFactor  as decimal no-undo.
        
        define variable newWidth    as integer no-undo.
        define variable newHeight   as integer no-undo.
        
        define variable zoomedImage as class   Image    no-undo.
        define variable g           as class   Graphics no-undo.
        
        zoomFactor = 0.9.
        
        if valid-object(pictureBox1:Image) then
        do:
    
            // Move the image to the zoom center
      
            transformationMatrix:Translate(zoomCenter:X, zoomCenter:Y). // Zoom out
            transformationMatrix:Scale(zoomFactor, zoomFactor). // Zoom out
            transformationMatrix:Translate(zoomCenter:X * -1, zoomCenter:Y * -1). // Move the image back
            
            g = pictureBox1:CreateGraphics().
            g:Clear(Color:White). // Clear the PictureBox
            g:Transform = transformationMatrix. // Apply the transformation matrix
            g:DrawImage(originalImage, new Point(0,0)). // Draw the image with the applied transformation
        
        end.
        
        return.

    end method.

    destructor public ABLImageViewer ( ):

    end destructor.

end class.

