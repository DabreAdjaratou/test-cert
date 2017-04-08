<?php

namespace Certification\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\TableGateway\AbstractTableGateway;

class ProviderTable extends AbstractTableGateway {

    private $tableGateway;

    public function __construct(TableGateway $tableGateway) {
        $this->tableGateway = $tableGateway;
    }

    public function fetchAll() {
        $sqlSelect = $this->tableGateway->getSql()->select();
        $sqlSelect->columns(array('certification_id','provider_id', 'last_name', 'first_name','middle_name', 'region', 'district', 'type_vih_test', 'phone', 'email', 'prefered_contact_method', 'current_jod','first_name','test_site_in_charge'));
        $sqlSelect->join('spi_rt_3_facilities', ' spi_rt_3_facilities.id = provider.facility_id ', array('facility_name'), 'left');
        $resultSet = $this->tableGateway->selectWith($sqlSelect);
        return $resultSet;
    }

    public function getProvider($certification_id) {
        $certification_id = (int) $certification_id;
        $rowset = $this->tableGateway->select(array('certification_id' => $certification_id));
        $row = $rowset->current();
        if (!$row) {
            throw new \Exception("Could not find row $certification_id");
        }
        return $row;
    }

    public function saveProvider(\Certification\Model\Provider $provider) {
        $data = array(
            'provider_id' => $provider->provider_id,
            'last_name' => $provider->last_name,
            'first_name' => $provider->first_name,
            'middle_name' => $provider->middle_name,
            'region' => $provider->region,
            'district' => $provider->district,
            'type_vih_test' => $provider->type_vih_test,
            'phone' => $provider->phone,
            'email' => $provider->email,
            'prefered_contact_method' => $provider->prefered_contact_method,
            'current_jod' => $provider->current_jod,
            'facility_id' => $provider->facility_id,
            'test_site_in_charge' => $provider->test_site_in_charge,
        );

//        print_r($data);
        $certification_id = (int) $provider->certification_id;

        if ($certification_id == 0) {

            $this->tableGateway->insert($data);
        } else {
            if ($this->getProvider($certification_id)) {
                $this->tableGateway->update($data, array('certification_id' => $certification_id));
            } else {
                throw new \Exception('Provider id does not exist');
            }
        }
    }
    
    public function fetchExam() {
        $sqlSelect = $this->tableGateway->getSql()->select();
        $sqlSelect->columns(array('certification_id','provider_id', 'last_name', 'first_name', 'middle_name', 'region', 'district', 'type_vih_test', 'phone', 'email', 'prefered_contact_method', 'current_jod', 'first_name', 'test_site_in_charge'));
        $sqlSelect->join('written_exam', 'written_exam.provider_id = provider.certification_id ', array('final_score'), 'left')
                  ->join('practical_exam', 'practical_exam.provider_id = provider.certification_id', array('practical_total_score'), 'left');
        $sqlSelect->order('last_name ASC');

        $resultSet = $this->tableGateway->selectWith($sqlSelect);
        return $resultSet;
    }

}