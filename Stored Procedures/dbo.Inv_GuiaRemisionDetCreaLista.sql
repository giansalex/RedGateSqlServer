SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetCreaLista]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Prod char(7),
@Descrip varchar(200),
@ID_UMP int,
@Cant numeric(13,3),
@PesoCantKg numeric(18,2),
@Cd_Vta nvarchar(10),
@Cd_Com char(10),
@ItemPd int,
@Pend numeric(13,3),
@UsuMdf nvarchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
	begin
		insert into GuiaRemisionDet(RucE,Cd_GR,Item,Cd_Prod,Descrip,ID_UMP,Cant,PesoCantKg,Cd_Vta,Cd_Com,ItemPd,Pend,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05)
			values(@RucE,@Cd_GR,dbo.ID_GRD(@RucE,@Cd_GR),@Cd_Prod,@Descrip,@ID_UMP,@Cant,@PesoCantKg,@Cd_Vta,@Cd_Com,@ItemPd,@Pend,getdate(),@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05)
		if @@rowcount <= 0
			set @msj = 'Detalle de Guia Remision no pudo ser registrado'	
	end
print @msj
-- Leyenda --
-- FL : 2010-12-07 : <Creacion del procedimiento almacenado>



GO
