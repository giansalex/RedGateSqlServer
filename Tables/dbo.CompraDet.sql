CREATE TABLE [dbo].[CompraDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL CONSTRAINT [DF_CompraDet_Cd_Com] DEFAULT (N'Codigo Compra'),
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SRV] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Valor] [numeric] (15, 7) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (15, 7) NULL,
[IMP_Ant] [numeric] (13, 2) NULL,
[IMP] [numeric] (15, 7) NOT NULL,
[IGV_Ant] [numeric] (13, 2) NULL,
[IGV] [numeric] (15, 7) NULL,
[PU_Ant] [numeric] (13, 2) NULL,
[PU] [numeric] (15, 7) NULL,
[Cant] [numeric] (20, 10) NOT NULL,
[Total] [numeric] (15, 7) NOT NULL,
[Cd_IA] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CA01] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[ItemOC] [int] NULL,
[IMPTot] [numeric] (15, 7) NULL,
[IGVTot] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       TRIGGER [dbo].[trig_CompraDet_DeleteMov] ON [dbo].[CompraDet]   
FOR DELETE   
AS
declare  
@RucE nvarchar(11),  
@Cd_OC char(10),  
@total_pend decimal(13,6),   
@totalcant decimal(13,6),  
@cd char(10),  
@Cd_Com char(10)  
  /*
select @RucE = RucE, @Cd_Com = Cd_Com from Deleted  
select @Cd_OC = c.Cd_OC from Compra c where c.RucE = @RucE and c.Cd_Com = @Cd_Com  
  
if(@Cd_OC is not null)  
begin
 --Calcula pendientes de OC con Com:  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from CompraDet i where i.RucE = c.RucE and i.Cd_Com = @Cd_Com and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC and c.Cd_Prod is not null) t  
 print @total_pend  
  
 --Calcula el total de productos de la OC:  
 --declare @totalcant decimal(13,6)  
 select @totalcant = sum(Cant) from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC  
 print @totalcant
  
-------------------  
 if(@total_pend = @totalcant)  
 begin  
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,1,''  
 end  
 else if(@total_pend > 0)  
 begin  
   exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,2,''  
 end  
 else if(@total_pend <= 0)  
 begin  
    exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,3,''  
 end  
 --print @total_pend  
end  
  */
--CAM 16/02/11 <Creacion del Trigger>  
--CAM 26/07/11 <Se comento todo porque ahora se controla mediante SP en el explorador de Compra luego de una eliminacion>
GO
ALTER TABLE [dbo].[CompraDet] ADD CONSTRAINT [PK_CompraDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Com], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompraDet] WITH NOCHECK ADD CONSTRAINT [FK_CompraDet_Compra] FOREIGN KEY ([RucE], [Cd_Com]) REFERENCES [dbo].[Compra] ([RucE], [Cd_Com])
GO
ALTER TABLE [dbo].[CompraDet] WITH NOCHECK ADD CONSTRAINT [FK_CompraDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[CompraDet] WITH NOCHECK ADD CONSTRAINT [FK_CompraDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[CompraDet] WITH NOCHECK ADD CONSTRAINT [FK_CompraDet_Servicio2] FOREIGN KEY ([RucE], [Cd_SRV]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_Com'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Indicador Afecto', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_IA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_SRV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Importe IGV Unitario', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'IGV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Base Imponible Unitaria', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'IMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Base Imponible', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'IMP_Ant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Precio Unitario con IGV', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'PU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Precio Unitario con IGV', 'SCHEMA', N'dbo', 'TABLE', N'CompraDet', 'COLUMN', N'PU_Ant'
GO
