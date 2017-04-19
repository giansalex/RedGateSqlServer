SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Cfg_EmpBaseCons]
@msj varchar(100) output
as

	if not exists (select top 1 *from CfgEmpsBase)
		set @msj='No existen empresas bases'
	else
	begin
		select  RucBase, Descrip from CfgEmpsBase where Estado=1
	end

-- Leyenda --
--JJ 11/02/2011 :<Creacion de procedimiento almacenado>
GO
