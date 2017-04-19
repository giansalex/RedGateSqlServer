SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Prov]
@RucE nvarchar(11)
as

declare @Consulta varchar(8000)

set @Consulta ='
Declare @Cd_Prv char(7)
declare @Cd_Aux varchar(100)
declare @Cd_TDI	nvarchar(2)
declare @NDoc varchar(15)
declare @RSocial varchar(150)
declare @ApPat varchar(20)
declare @ApMat varchar(20)
declare @Nom varchar(20)
declare @Cd_Pais nvarchar(4)
declare @CodPost varchar(10)
declare @Ubigeo	nvarchar(6)
declare @Direc varchar(100)
declare @Telf1 varchar(20)
declare @Telf2 varchar(20)
declare @Fax varchar(20)
declare @Correo	varchar(50)
declare @PWeb varchar(100)
declare @Obs varchar(200)
declare @Cta nvarchar(10)
declare @Estado	bit
declare @CA01 varchar(100)
declare @CA02 varchar(100)
declare @CA03 varchar(100)
declare @CA04 varchar(100)
declare @CA05 varchar(100)
declare @CA06 varchar(100)
declare @CA07 varchar(100)
declare @CA08 varchar(100)
declare @CA09 varchar(300)
declare @CA10 varchar(300)

Declare _cursor Cursor 
	For SELECT 
		Cd_Aux, Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom,
		case(len(Cd_Pais)) when 0 then ''9589'' else Cd_Pais end as Cd_Pais,
		CodPost, Ubigeo, Direc, Telf1, Telf2, Fax, Correo, PWeb, Obs, Cta,
		Estado, CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10
from 
	OPENROWSET(''SQLOLEDB'', ''netserver'';''Usu123_1'';''user123'',
	    ''select 
			a.*,case when b.Cta is null then c.Cta else b.Cta end as Cta
	    from 
			Auxiliar a
			left join Proveedor b on b.RucE=a.RucE and b.Cd_Aux=a.Cd_Aux
			left join Cliente c on c.RucE=a.RucE and c.Cd_Aux=a.Cd_Aux
	    where 
			a.RucE='''''+@RucE+''''' 
	    and a.Cd_Aux in 
			(SELECT  
				a.Cd_Aux 
			 from 
				auxiliar a 
			 inner join Voucher b on b.RucE=a.RucE and b.Cd_Aux=a.Cd_Aux and b.Cd_Fte=''''RC''''
			 where 
				a.RucE='''''+@RucE+''''' 
			 group by 
				a.Cd_Aux) 
		order by 
			 Cta desc,
			 a.Cd_Aux
	'' ) 
	--where Cd_TDI+''''+NDoc not in(select Cd_TDI+''''+NDoc from Proveedor2 where RucE='''+@RucE+''') and RucE='''+@RucE+'''
		
open _cursor
	Fetch next from _cursor into @Cd_Aux, @Cd_TDI, @NDoc, @RSocial, @ApPat, @ApMat, @Nom, @Cd_Pais,	@CodPost, @Ubigeo, @Direc, @Telf1, @Telf2, @Fax, @Correo, @PWeb, @Obs, @Cta, @Estado, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10
	while @@FETCH_STATUS = 0
		Begin
		set @Cd_Prv=dbo.Cod_Prv2('''+@RucE+''')
		if(select count(*) from Proveedor2 where RucE='''+@RucE+''' and Cd_TDI=@Cd_TDI and NDoc=@NDoc) = 0
		Begin
			insert into Proveedor2(RucE,Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,CtaCtb,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_SjDet)
				values('''+@RucE+''',@Cd_Prv,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@Cta,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@Cd_Aux,0)
		End
		Else
		Begin
			Update 
				Proveedor2 
			Set 
				CA10=@Cd_Aux 
			Where 
				RucE='''+@RucE+''' 
				and Cd_TDI=@Cd_TDI 
				and NDoc=@NDoc
		End
		Fetch next from _cursor into @Cd_Aux, @Cd_TDI, @NDoc, @RSocial, @ApPat, @ApMat, @Nom, @Cd_Pais,	@CodPost, @Ubigeo, @Direc, @Telf1, @Telf2, @Fax, @Correo, @PWeb, @Obs, @Cta, @Estado, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10
		end
Close _cursor
Deallocate _cursor'

print @Consulta
Exec(@Consulta)
--Leyenda
--01/06/2011 Creacion del procedimiento almacenado
GO
