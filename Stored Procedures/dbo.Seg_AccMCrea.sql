SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccMCrea]
@Cd_GA int,
@Cd_MN nvarchar(10),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from AccesoM where Cd_GA=@Cd_GA and Cd_MN=@Cd_MN)
	set @msj = 'Acceso ya existe'
else
begin
	insert into AccesoM(Cd_GA,Cd_MN,Estado)
		     values(@Cd_GA,@Cd_MN,1)

	if @@rowcount <= 0
           set @msj = 'Acceso no pudo ser registrado'
end
print @msj


GO
