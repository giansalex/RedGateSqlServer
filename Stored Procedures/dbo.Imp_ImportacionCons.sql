SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionCons]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as
--set @RucE='11111111111'
--set @Ejer='2011'
if not exists(select * from importacion where RucE=@RucE and Ejer=@Ejer)
	set @msj='no tiene importaciones'
else
begin
select *from importacion where RucE=@RucE and Ejer=@Ejer
end
GO
