SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_DevuelveCodVta_X_NDNR]
@RucE nvarchar(11),
--====================
@Cd_TD nvarchar(2),
@NroSerie nvarchar(5),
@NroDoc nvarchar(15),
--====================
@RegCtb nvarchar(15),
--====================
@Cd_Vta nvarchar(10) output,
--====================
@msj varchar(100) output
as
if(len(@NroSerie)>0 or len(@NroDoc)>0)
begin
--declare @Cd_Sr nvarchar(4)
--set @Cd_Sr = '0'
	--set @Cd_Sr = (select Cd_Sr from Serie where RucE=@RucE and Cd_TD=@Cd_TD and NroSerie=@NroSerie)

--select * from Venta // WHAT DA FAAAAQ ??!! QUE HACE ESTO AQUI !!! (*)

	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSerie and NroDoc=@NroDoc)
	if (@Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
end
   else if (len(@RegCtb)>0)
        begin
		set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and RegCtb=@RegCtb)
		if (@Cd_Vta = null or @Cd_Vta is null)
		begin
			set @msj = 'Nro de registro no pertenece a ninguna venta'
			return
		end
	end
     else set  @msj = 'Información no válida'



--LEYENDA
--J -> Corregido : Por el comentario con (*), no se que tenia que ver esa sentencia en este procedimiento y no habia leyenda como para no hecharle la culpa a alguien ¬_¬
GO
