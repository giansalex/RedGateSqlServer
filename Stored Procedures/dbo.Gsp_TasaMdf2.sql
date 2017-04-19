SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaMdf2]
@Cd_Ts nvarchar(3),
@Porc numeric(5),
@EjerPrdovig nchar(10),
@EjerPrdovig1 nchar(10), 
@msj varchar(100) output
as

--Declare @FechaAnterior nchar(20)
--set @FechaAnterior = (select MAX(EjerPrdovig) from TasasHist where Cd_Ts=@Cd_Ts)
 

if not exists (select * from Tasashist where Cd_Ts=@Cd_Ts or EjerPrdovig=@EjerPrdovig or Porc=@Porc)
	set @msj = 'Tasa no existe'
else
begin

	--insert into tasashist (Cd_Ts,EjerPrdovig,Porc) values (@Cd_Ts,@Fecha,@Tasa) 
	 
	update TasasHist set EjerPrdovig=@EjerPrdovig , Porc=@Porc
	where Cd_Ts=@Cd_Ts and EjerPrdovig=@EjerPrdovig1
	
	if @@rowcount <= 0
	   set @msj = 'Tasa no pudo ser modificado'
end
print @msj
GO
