SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocIdnCrea]
@Cd_TDI nvarchar(2),
@Descrip varchar(50),
@NCorto varchar(6),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipDocIdn where Cd_TDI=@Cd_TDI)
	set @msj = 'Tipo de documento de identdad ya existe'
else
begin
	insert into TipDocIdn(Cd_TDI,Descrip,NCorto,Estado)
	          values(@Cd_TDI,@Descrip,@NCorto,1)
	
	if @@rowcount <= 0
		set @msj = 'Tipo de documento de identidad no pudo ser ingresado'
end
print @msj
GO
