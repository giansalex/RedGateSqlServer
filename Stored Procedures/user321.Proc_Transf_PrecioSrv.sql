SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
		
CREATE procedure [user321].[Proc_Transf_PrecioSrv]
@RucE nvarchar(11)
as
--declare @RucE nvarchar (11)
  	     

		--SP_Help precioSrv
		--set @ID_PrSv=dbo.Id_PrecioSrv('20512635025')
		--select @ID_PrSv
Declare @Consulta Varchar(MAX)

set @Consulta='
	declare @ID_PrSv int
	declare @Cd_Srv	char(7)
	declare @Descrip varchar (100)
	declare @Cd_Mda	nvarchar (2)
	declare @PVta numeric(13,2)    
	declare @IB_IncIGV bit
	declare @IB_Exrdo bit
	declare @ValVta numeric(13,2)
	declare @IC_TipDscto char(1)
	declare @Dscto numeric(13,2)
	declare @IC_TipVP varchar(1)
	declare @MrgInf	numeric(13,2)
	declare @MrgSup	numeric(13,2)
	declare @Estado	bit
	
	Declare _Cursor Cursor
	
	For SELECT 
		Cd_Srv, Descrip, Cd_Mda, PVta, IB_IncIGV, IB_Exrdo, ValVta, IC_TipDscto, Dscto,IC_TipVP, MrgInf, MrgSup, Estado
	from 
		OPENROWSET(''SQLOLEDB'',
	    ''netserver'';''Usu123_1'';''user123'',
	    ''select 
			b.RucE, 0 as ID_PrSv, Cd_Srv, isnull(Descrip,'''''''') as Descrip, 
			Cd_Mda, PrecioVta as PVta, IB_IncIGV, IB_Exrdo, ValorVta as ValVta,
			IC_TipDcto as IC_TipDscto, isnull(Dcto,0.00) as Dscto, ''''I'''' as IC_TipVP, 0.00 as MrgInf, 0.00 as MrgSup, b.Estado
		from 
			Servicio a 
			inner join producto b on a.RucE=b.RucE and a.Cd_Srv=b.Cd_Pro
		where 
			b.RucE='''''+@RucE+''''' '')
	
	Open _Cursor
	
	Fetch Next From _Cursor Into @Cd_Srv, @Descrip, @Cd_Mda, @PVta, @IB_IncIGV, @IB_Exrdo, @ValVta, @IC_TipDscto, @Dscto, @IC_TipVP, @MrgInf, @MrgSup, @Estado
	While @@Fetch_Status = 0
		Begin
			set @ID_PrSv=dbo.Id_PrecioSrv('''+@RucE+''')
			
			Insert into PrecioSrv(RucE,ID_PrSv,Cd_Srv,Descrip,Cd_Mda,PVta,IB_IncIGV,IB_Exrdo,ValVta,IC_TipDscto,Dscto,IC_TipVP,MrgInf,MrgSup,Estado)
				Values('''+@RucE+''',@ID_PrSv,@Cd_Srv,@Descrip,@Cd_Mda,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@IC_TipVP,@MrgInf,@MrgSup,@Estado)
			Fetch Next From _Cursor Into @Cd_Srv, @Descrip, @Cd_Mda, @PVta, @IB_IncIGV, @IB_Exrdo, @ValVta, @IC_TipDscto, @Dscto, @IC_TipVP, @MrgInf, @MrgSup, @Estado
		End
Close _Cursor
Deallocate _Cursor'

print @Consulta
exec (@Consulta)

-- exec [user321].[Proc_Transf_PrecioSrv] '11111111111'
GO
