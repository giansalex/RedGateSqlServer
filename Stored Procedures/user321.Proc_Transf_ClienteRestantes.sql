SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_ClienteRestantes]
@RucE nvarchar(11)
as

declare @Consulta varchar(MAX)

set @Consulta='
	declare @Cd_Clt char(10)
	declare @Cd_TDI nvarchar(2)
	declare @NDoc varchar(15)
	declare @RSocial varchar(150)
	declare @ApPat varchar(20)
	declare @ApMat varchar(20)
	declare @Nom varchar(20)
	declare @Cd_Pais nvarchar(4)
	declare @CodPost varchar(10)
	declare @Ubigeo nvarchar(6)
	declare @Direc varchar(100)
	declare @Telf1 varchar(20)
	declare @Telf2 varchar(20)
	declare @Fax varchar(20)
	declare @Correo varchar(50)
	declare @PWeb varchar(100)
	declare @Obs varchar(200)
	declare @Estado bit
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
	declare @Cd_Aux varchar(100)
	declare @Cta nvarchar(10)


	Declare _Cursor Cursor
	For SELECT 
			Cd_Aux, Cd_TDI, NDoc, Case when Len(RSocial)=0 then null else RSocial End As RSocial,ApPat,ApMat,Nom,
			Case when len(Cd_Pais)=0 then ''9589'' else Cd_Pais end As Cd_Pais,
			case when len(CodPost)=0 then null else CodPost end as CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,
			Obs,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,
			case when Cta is null then ''9999999999'' else Cta end as Cta
		from OPENROWSET(''SQLOLEDB'',
		''netserver'';''Usu123_1'';''user123'',
		''SELECT 
			a.*,
			case when b.Cta is null then c.Cta else b.Cta end as Cta
		 from 
			dbo.Auxiliar a 
			left join Cliente b on b.RucE=a.RucE and b.Cd_aux=a.Cd_Aux
			left join proveedor c on c.RucE=a.RucE and c.Cd_Aux=a.Cd_Aux
		 where 
			a.RucE='''''+@RucE+''''' and a.Cd_TA in (''''01'''',''''98'''') '')
	Open _Cursor
	Fetch Next From _Cursor Into @Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cta
	While @@Fetch_Status = 0
		Begin
			set @Cd_Clt = dbo.Cod_Clt2('''+@RucE+''')
			if (select Count(*) from cliente2 where RucE='''+@RucE+''' and Cd_TDI=@Cd_TDI and NDoc=@NDoc) = 0
			Begin
				insert into Cliente2(RucE,Cd_Clt,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2,Fax,Correo,PWeb,Obs,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_Aux,CtaCtb)
					Values ('''+@RucE+''',@Cd_Clt,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_Aux,@Cta)
			End
			Else
			Begin
				Update 
					Cliente2
				Set 
					Cd_Aux=@Cd_Aux
				Where
					RucE='''+@RucE+'''
					and Cd_TDI=@Cd_TDI
					and NDoc=@NDoc
			End
		Fetch Next From _cursor Into @Cd_Aux,@Cd_TDI,@NDoc,@RSocial,@ApPat,@ApMat,@Nom,@Cd_Pais,@CodPost,@Ubigeo,@Direc,@Telf1,@Telf2,@Fax,@Correo,@PWeb,@Obs,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cta
		End

	Close _cursor
	Deallocate _cursor			
'
						
print @Consulta
Exec(@Consulta)
--Exec user321.Proc_Transf_ClienteRestantes '11111111111'
GO
