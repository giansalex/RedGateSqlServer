SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Producto]
as
declare @RucE nvarchar(11)
declare @Cd_Prod char(7)
declare @Nombre varchar(100)
declare @Descrip varchar(200)
declare @Cta1 nvarchar(10)
declare @Cta2 nvarchar(10)
declare @CodCo varchar(20)
declare @Cd_CC nvarchar(8)
declare @Cd_SC nvarchar(8)
declare @Cd_SS nvarchar(8)

set @RucE='20266194324'
Declare _cursor Cursor 
	For SELECT RucE,Cd_Pro,Nombre,Descrip,Cta1,Cta2,CodCo,Cd_CC,Cd_SC,Cd_SS
	from OPENROWSET('SQLOLEDB','DataServer';'User123';'user123',
	'select RucE,Cd_Pro,Nombre,Descrip,Cta1,Cta2,CodCo,Cd_CC,Cd_SC,Cd_SS from Producto
	where RucE=''20266194324''')
Open _cursor
	Fetch Next From _cursor Into @RucE,@Nombre,@Descrip,@Cta1,@Cta2,@CodCo,@Cd_CC,@Cd_SC,@Cd_SS
	While @@Fetch_Status = 0
		Begin
			set @Cd_Prod=dbo.Cod_Prod2(@RucE)
			insert into Producto2(RucE,Cd_Prod,Nombre1,Descrip,Cta1,Cta2,CodCo1_,Cd_CC,Cd_SC,Cd_SS,Estado)
				values(@RucE,@Cd_Prod,@Nombre,@Descrip,@Cta1,@Cta2,@CodCo,@Cd_CC,@Cd_SC,@Cd_SS,1)
		Fetch Next From _cursor Into @RucE,@Nombre,@Descrip,@Cta1,@Cta2,@CodCo,@Cd_CC,@Cd_SC,@Cd_SS
		End
Close _cursor
Deallocate _cursor
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
GO
