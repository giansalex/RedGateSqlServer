SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_ValidaNroDocV]
@RucE nvarchar(11),
@Ejer nvarchar(4),-- JS : no debería, no es usado tampoco
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@Cd_Vta nvarchar(20) output,
@FecED smalldatetime output,
@msj varchar(100) output
as
if not exists(select * from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc)
		set @msj = 'No existe ningun documento'+@Cd_TD+' '+@NroSre+'-'+@NroDoc
else 
	select @Cd_Vta=Cd_Vta,@FecED=FecED from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc

/*else
begin
	select top 1 RucE,Ejer,RegCtb,FecED,Cd_TD,NroSre,NroDoc,'' as FecEDRef,'' as Cd_TDRef,'' as NroSreRef, '' as NroDocRef from voucher
	where RucE=@RucE and Ejer=@Ejer and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
	
end*/
print @msj
print @Cd_Vta
print @FecED
--sp_help venta
GO
