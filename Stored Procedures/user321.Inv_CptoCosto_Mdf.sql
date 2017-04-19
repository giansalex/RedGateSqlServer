SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [user321].[Inv_CptoCosto_Mdf]
@RucE nvarchar(11),
@Cd_Cos char(2),
@CodSNT_ varchar(4),
@Descrip varchar(250),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as

if not exists(select * from CptoCosto where Cd_Cos = @Cd_Cos and RucE = @RucE)
begin
	set @msj = 'No existe el concepto de costo'
	return
end

update CptoCosto
set 
	CodSNT_ = @CodSNT_,
	Descrip = @Descrip,
	NCorto = @NCorto,
	Estado = @Estado
where Cd_Cos = @Cd_Cos and RucE = @RucE

GO
