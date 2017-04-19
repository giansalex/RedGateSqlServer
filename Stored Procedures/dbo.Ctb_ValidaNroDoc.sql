SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_ValidaNroDoc]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@msj varchar(100) output
as
if not exists(select * from voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc)
		set @msj = 'No existe ningun documento'+@Cd_TD+' '+@NroSre+'-'+@NroDoc

/*else
begin
	select top 1 RucE,Ejer,RegCtb,FecED,Cd_TD,NroSre,NroDoc,'' as FecEDRef,'' as Cd_TDRef,'' as NroSreRef, '' as NroDocRef from voucher
	where RucE=@RucE and Ejer=@Ejer and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
	
end*/
print @msj

GO
