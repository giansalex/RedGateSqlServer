SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_DirecEntCons]
@RucE nvarchar(11),
@Cd_Clt char(10),
@TipCons int,
@msj varchar(100) output
as
begin
	    if(@TipCons=0)
	    begin
		select Item, Direc,obs from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt
	    end
end
print @msj
GO
