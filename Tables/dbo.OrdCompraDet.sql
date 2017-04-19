CREATE TABLE [dbo].[OrdCompraDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SRV] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Valor] [numeric] (15, 7) NULL,
[Valor_Ant] [numeric] (13, 2) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (15, 7) NULL,
[BIM] [numeric] (15, 7) NULL,
[BIM_Ant] [numeric] (13, 2) NULL,
[IGV] [numeric] (15, 7) NULL,
[IGV_Ant] [numeric] (13, 2) NULL,
[PU] [numeric] (15, 7) NULL,
[PU_Ant] [numeric] (13, 2) NULL,
[Cant] [numeric] (20, 10) NULL,
[Total] [numeric] (15, 7) NULL,
[PendRcb] [numeric] (13, 3) NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (5000) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AtSrv] [bit] NULL,
[ItemSC] [int] NULL,
[BIMTot] [numeric] (15, 7) NULL,
[IGVTot] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        TRIGGER [dbo].[trig_OrdCompraDet_DeleteMov] ON [dbo].[OrdCompraDet]   
FOR DELETE   
AS  
-- select * from OrdCompra where RucE = '11111111111' and Cd_OC = 'OC00000080'  
-- select * from OrdCompraDet where RucE = '11111111111' and Cd_OC = 'OC00000080'  
-- Pruebas:  
-- Com_VerificaPendientes_SolicitudReq '11111111111','SR00000029',''  
-- select RucE,Cd_SR,Id_EstSR from SolicitudReq where RucE = '11111111111' and Cd_SR = 'SR00000029'  
  
declare  
@RucE nvarchar(11),  
@Cd_SCo char(10),  
@total_pend decimal(13,6),   
@totalcant decimal(13,6),  
@cd char(10),  
@Cd_OC char(10)  
  
select @RucE = RucE, @Cd_OC = Cd_OC from Deleted  
select @Cd_SCo = sc.Cd_SCo from OrdCompra sc where sc.RucE = @RucE and sc.Cd_OC = @Cd_OC  
  
if(@Cd_SCo is not null)  
begin  
 --Calcula pendientes:  
 select @cd = Cd_OC from OrdCompra where RucE = @RucE and Cd_SCo = @Cd_SCo  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from OrdCompraDet i where i.RucE = c.RucE and i.Cd_OC = @cd and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from SolicitudComDet c where c.RucE = @RucE and c.Cd_SC = @Cd_SCo and c.Cd_Prod is not null) t  
  
 --Calcula el total de productos de la SC:  
 select @totalcant = sum(Cant) from SolicitudComDet c where c.RucE = @RucE and c.Cd_SC = @Cd_SCo  
  
-------------------  
  
 if(@total_pend = @totalcant)  
 begin  
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,7,''   
 end  
 else if(@total_pend > 0)  
 begin  
   exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,8,''   
 end  
 else if(@total_pend <= 0)  
 begin  
    exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,9,''   
 end  
 --print @total_pend  
end  
  
--CAM 15/02/11 <Creacion del Trigger>
GO
ALTER TABLE [dbo].[OrdCompraDet] ADD CONSTRAINT [PK_OrdCompraDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OC], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompraDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompraDet_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[OrdCompraDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompraDet_OrdCompra] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra] ([RucE], [Cd_OC])
GO
ALTER TABLE [dbo].[OrdCompraDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompraDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompraDet', 'COLUMN', N'Cd_SRV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompraDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para Servicios Atendidos', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompraDet', 'COLUMN', N'IB_AtSrv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(No se va a usar) Pendientes x Recibir', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompraDet', 'COLUMN', N'PendRcb'
GO
