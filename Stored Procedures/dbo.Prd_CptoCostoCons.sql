SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_CptoCostoCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
declare @check bit
set @check = 0
	begin
		select @check as sel ,cc.*
		from cptocosto cc
		where cc.RucE=@RucE and cc.Estado=1
		--order by cc.Cd_Cos asc
		order by cc.CodSNT_ asc
	end

print @msj
-- Leyenda --
-- FL : 2011-02-25 : <Creacion del procedimiento almacenado>
--exec Prd_CptoCostoCons '11111111111',null
GO
