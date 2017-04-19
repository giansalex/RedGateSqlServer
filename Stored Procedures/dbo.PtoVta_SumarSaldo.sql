SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[PtoVta_SumarSaldo]

@Ruce nvarchar(11),
@Saldo decimal,
@Cd_Clt char(10),
@msj nvarchar(100) output

as

if exists (select * from Cliente2 where RucE =@RucE and Cd_Clt=@Cd_Clt and SaldoAFavor is null)
	begin
		Update Cliente2 set SaldoAFavor = 0 where RucE =@RucE and Cd_Clt=@Cd_Clt
		
	end 

Update Cliente2 set SaldoAFavor = SaldoAFavor+@Saldo where RucE =@RucE and Cd_Clt=@Cd_Clt

print @msj
	
GO
