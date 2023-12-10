#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Credits : WillyRL

import os
import plugins

class Plugin(plugins.BasePlugin):
    __name__ = 'idch-exim'

    def run(self, config):
        '''
        idch-exim mail queue monitoring, needs sudo access!
        Exim Instructions at:
        https://help.nixstats.com/en/article/monitoring-exim-mail-queue-size-1vcukxa/
        '''
        data = {}
        data['queue_size'] = int(os.popen('sudo exim -bpc').read())
        data['frozen_queue'] = int(os.popen('sudo exim -bp|grep frozen|wc -l').read())
	return data
	

if __name__ == '__main__':
    Plugin().execute()
