SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Gsp_CCostosPspCons]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @Cd_CC varchar(8)
Declare @Cd_SC varchar(8)
Declare @Cd_SS varchar(8)

Set @RucE='11111111111' 
Set @Ejer='2010'
Set @Cd_CC='0002'
Set @Cd_SC='0002.1'
Set @Cd_SS='01010101'
*/

Select c.Cd_CC,'' As Cd_SC, '' As Cd_SS, c.Descrip
       ,Case When Count(p.NroCta)>0 Then '1' Else '0' End As contieneReg
from CCostos c
	Left Join Presupuesto p On p.RucE=c.RucE and p.Ejer=@Ejer and p.Cd_CC=c.Cd_CC --and Case When isnull(@Cd_SC,'')='' Then '' Else p.Cd_SC End=isnull(@Cd_SC,'') and Case When isnull(@Cd_SS,'')='' Then '' Else p.Cd_SS End=isnull(@Cd_SS,'')
Where c.RucE=@RucE 
	and c.Cd_CC=@Cd_CC 
	and c.IB_Psp<>0
Group by c.Cd_CC,c.Descrip
		

UNION ALL


Select c.Cd_CC,c.Cd_SC, '' As Cd_SS,c.Descrip 
       ,Case When Count(p.NroCta)>0 Then '1' Else '0' End As contieneReg
from CCSub c
	Left Join Presupuesto p On p.RucE=c.RucE and p.Ejer=@Ejer and p.Cd_CC=c.Cd_CC and Case When isnull(c.Cd_SC,'')='' Then '' Else p.Cd_SC End=isnull(c.Cd_SC,'') --and Case When isnull(@Cd_SS,'')='' Then '' Else p.Cd_SS End=isnull(@Cd_SS,'')
Where c.RucE=@RucE 
	and c.Cd_CC=@Cd_CC 
	and Case When isnull(@Cd_SC,'')='' Then '' Else c.Cd_SC End=isnull(@Cd_SC,'') 
	and c.IB_Psp<>0
Group by c.Cd_CC,c.Cd_SC,c.Descrip
		
				
UNION ALL


Select c.Cd_CC,c.Cd_SC,c.Cd_SS,c.Descrip
       ,Case When Count(p.NroCta)>0 Then '1' Else '0' End As contieneReg
from CCSubSub c
	Left Join Presupuesto p On p.RucE=c.RucE and p.Ejer=@Ejer and p.Cd_CC=c.Cd_CC and Case When isnull(c.Cd_SC,'')='' Then '' Else p.Cd_SC End=isnull(c.Cd_SC,'') and Case When isnull(c.Cd_SS,'')='' Then '' Else p.Cd_SS End=isnull(c.Cd_SS,'')
Where c.RucE=@RucE 
	and c.Cd_CC=@Cd_CC 
	and Case When isnull(@Cd_SC,'')='' Then '' Else c.Cd_SC End=isnull(@Cd_SC,'') 
	and Case When isnull(@Cd_SS,'')='' Then '' Else c.Cd_SS End=isnull(@Cd_SS,'') 
	and c.IB_Psp<>0
Group by c.Cd_CC,c.Cd_SC,c.Cd_SS,c.Descrip


-- Leyenda --
-- Di : 06/01/2011 <Creacion del procedimiento almacenado>
GO
