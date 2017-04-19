SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Cfg_RegCtbCobro]
@RucE nvarchar(15)
as
Declare _cursor Cursor 
	For Select c.ItmCo,right('00'+ltrim(Convert(nvarchar,month(c.FecPag))),2) as Mes,a.NCorto from Cobro c left join Venta v On v.RucE=c.RucE and v.Cd_Vta=c.Cd_Vta  left join Area a On a.RucE=c.RucE and v.Cd_Area=a.Cd_Area where c.RucE=@RucE and isnull(c.RegCtb,'0') = '0'

Declare @SQL nvarchar(4000)
Declare @NroTemp int
Declare @Num nvarchar(15)
Declare @Cd_Cbr int,@Mes nvarchar(2),@Area nvarchar(6)

Open _cursor
	Fetch Next From _cursor Into @Cd_Cbr,@Mes,@Area
	While @@Fetch_Status = 0
		Begin
			Set @NroTemp = (select isnull(convert(int,right(Max(RegCtb),5)),0)+1 from Cobro where RucE=@RucE and left(RegCtb,10)='VT'+@Area+'_CB'+@Mes+'-')	
			Set @Num = 'VT'+@Area+'_CB'+@Mes+'-'+right('00000'+ltrim(Convert(nvarchar,@NroTemp)),5)
			Update Cobro Set RegCtb=@Num where RucE=@RucE and ItmCo=@Cd_Cbr
		Fetch Next From _cursor Into @Cd_Cbr,@Mes,@Area
		End
Close _cursor
Deallocate _cursor


GO
